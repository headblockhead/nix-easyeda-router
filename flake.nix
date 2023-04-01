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
  installPhase = ''
  mkdir -p $out/bin
  ln -sf ${pkgs.jdk}/bin/java $out/bin/java
    printf "$out/bin/java -XX:+UseG1GC -Dcom.easyeda.env=local -jar $out/opt/easyeda-router-linux-x64-v0.8.11/bin/bootstrap.jar" > $out/bin/easyeda-router
    chmod +x $out/bin/easyeda-router
  '';
  unpackPhase = ''
  mkdir $out
  mkdir $out/opt
  jar xvf $src
  mv easyeda-router-linux-x64-v0.8.11 $out/opt
  '';
};
  in
  {
    packages.x86_64-linux.easyeda-router = easyeda-router;
    defaultPackage.x86_64-linux = easyeda-router;
  };
}
