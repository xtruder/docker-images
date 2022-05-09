{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-21.11.tar.gz") { } }:

pkgs.mkShell {
  # nativeBuildInputs is usually what you want -- tools you need to run
  nativeBuildInputs = with pkgs; [
    nixpkgs-fmt
    rnix-lsp
    docker-client
  ];

  hardeningDisable = [ "all" ];

  shellHook = ''
  '';
}