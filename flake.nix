{
  description = "Open Audible for accessing audio books.";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
  };

  outputs = {
    self, nixpkgs, ...
  }:

  let 
    supportedSystems = [
      "x86_64-linux"
    ];
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
  in 
  {
    packages = forAllSystems (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        # default = let 
        #   openaudible = import ./openaudible.nix { 
        #     lib=pkgs.lib; 
        #     appimageTools=pkgs.appimageTools; 
        #     stdenv=pkgs.stdenv; 
        #     fetchurl=pkgs.fetchurl;
        #     makeDesktopItem=pkgs.makeDesktopItem;
        #   };
        # in
        #   pkgs.writeShellScriptBin "openaudible" ''
        #     set -x
        #     echo ${openaudible}
        #     ${pkgs.jdk}/bin/java -jar ${openaudible}/share/openaudible/resources/openaudible.jar
        #   '';

        default = pkgs.callPackage ./openaudible.nix { 
          lib=pkgs.lib; 
          appimageTools=pkgs.appimageTools; 
          stdenv=pkgs.stdenv; 
          fetchurl=pkgs.fetchurl;
          };
        
      });
  };
}
