{
  description = "Entorno Orange3 ultra simplificado";
  
  inputs={
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
  };


  #nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
  
  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          # Orange3 desde python packages
          python3Packages.orange3
          
          # Python base
          python3
          ];
        
        shellHook = ''
          echo "🍊 Entorno Orange3 activado"
          echo ""
          echo "Comandos disponibles:"
          echo "  orange-canvas    - Iniciar Orange3 GUI"
          echo "  python3          - Python con Orange3 disponible"
          echo ""
          echo "Para usar Orange3 en Python:"
          echo "  >>> import Orange"
          echo "  >>> Orange.__version__"
          echo ""
        '';
      };
      
      # Para ejecutar directamente
      apps.${system}.default = {
        type = "app";
        program = "${pkgs.python3Packages.orange3}/bin/orange-canvas";
      };
    };
}

