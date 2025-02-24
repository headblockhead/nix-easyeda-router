{
  description = "The EasyEDA Auto Router that can run locally.";

  outputs = { self, nixpkgs }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
      };
      easyeda-router = pkgs.stdenv.mkDerivation {
        pname = "easyeda-router";
        version = "0.8.11";
        src = pkgs.fetchurl {
          url = "https://image.easyeda.com/files/easyeda-router-linux-x64-v0.8.11.zip";
          sha256 = "GIxxq93Cmr2lyqtufrsVjBuqRd/OxuDhjxUKJTzeE4M=";
        };
        buildInputs = [ pkgs.jdk ];
        unpackPhase = ''
          mkdir -p $out/opt
          jar xvf $src
          mv easyeda-router-linux-x64-v0.8.11 $out/opt
        '';
      };
      easyeda-router-script = pkgs.writeShellApplication {
        name = "easyeda-router";
        runtimeInputs = [ easyeda-router pkgs.jdk ];
        text = ''
          java -XX:+UseG1GC -Dcom.easyeda.env=local -jar ${easyeda-router}/opt/easyeda-router-linux-x64-v0.8.11/bin/bootstrap.jar
        '';
      };
    in
    {
      packages.x86_64-linux.easyeda-router = easyeda-router;
      apps.x86_64-linux.default = {
        type = "app";
        program = "${easyeda-router-script}/bin/easyeda-router";
      };
    };
}
