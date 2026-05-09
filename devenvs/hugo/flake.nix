{
  description ="Emtorno de desarrollo para HUGO + stack theme";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
  flake-utils.lib.eachDefaultSystem (system:
  let
    pkgs = nixpkgs.legacyPackages.${system};
  in {
 buildInputs = [ pkgs.zsh ];
    devShells.default = pkgs.mkShell {
      name = "hugo-dev";
      
      packages = with pkgs; [
        hugo
        go
        nodejs_20
        nodePackages.npm
        just
        watchman
      ];

      buildInputs = [ pkgs.zsh ];
      shellHook = ''
            echo ""
            echo "  Hugo dev environment"
            echo "  Hugo:    $(hugo version | head -c 40)"
            echo "  Git:     $(git --version)"
            echo "  Go:      $(go version | awk '{print $3}')"
            echo ""
            echo "  Comandos:"
            echo "  hugo server -D       → servidor local con borradores"
            echo "  hugo new post/...    → nuevo artículo"
            echo "  hugo build           → build de producción"
            echo ""
            '';
    };
  }
   );
}
