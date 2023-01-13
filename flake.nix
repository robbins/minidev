{
  description = "Flakeified minidev";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }: 
  let
    pkgs = import nixpkgs { system = "x86_64-linux"; };
  in {
    packages.x86_64-linux.minidev = pkgs.stdenvNoCC.mkDerivation {
      pname = "minidev";
      version = "1.2.0";
      src = ./.;
      buildInputs = [ pkgs.ruby ];
      installPhase = ''
        mkdir $out
        rm vendor/fzy_*
        ln -s ${pkgs.fzy}/bin/fzy vendor/fzy_${if pkgs.stdenv.isDarwin then "darwin" else "linux"}
        cp -R $src/dev.sh $src/bin $src/lib vendor $out
        chmod +x $out/bin/dev
      '';
    };
    packages.x86_64-linux.default = self.packages.x86_64-linux.minidev;
    homeModules.default = import ./modules/minidev-hm.nix self;
  };
}
