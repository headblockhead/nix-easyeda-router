{
  description = "The EasyEDA Auto Router that can run locally.";

  outputs = { self, nixpkgs }:
  let
        pkgs = import nixpkgs {
      system = "x86_64-linux";
    };
    easyeda-router = pkgs.callPackage ./default.nix { };
  in
  {
    packages.x86_64-linux.easyeda-router = easyeda-router;
    defaultPackage.x86_64-linux = easyeda-router;
  };
}
