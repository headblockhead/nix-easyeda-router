{ pkgs ? import <nixpkgs> {} }:
let 
  easyeda-router = import ./default.nix { inherit pkgs; };
in
  pkgs.mkShell {
    nativeBuildInputs = [ easyeda-router ];
}
