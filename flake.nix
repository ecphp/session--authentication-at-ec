{
  description = "European Commission beamer presentation";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    ec-theme.url = "git+https://code.europa.eu/pol/european-commission-latex-beamer-theme/";
    ec-fonts.url = "git+https://code.europa.eu/pol/ec-fonts/";
    ci-detector.url = "github:loophp/ci-detector";
  };

  outputs = { self, nixpkgs, flake-utils, ec-theme, ec-fonts, ci-detector, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        version = self.shortRev or self.lastModifiedDate;

        pkgs = import nixpkgs {
          inherit system;

          overlays = [
            ec-theme.overlays.default
            ec-fonts.overlays.default
          ];
        };

        pandoc = pkgs.writeShellScriptBin "pandoc" ''
          ${pkgs.pandoc}/bin/pandoc --data-dir ${pkgs.pandoc-template-ec} $@
        '';

        tex = pkgs.texlive.combine {
            inherit (pkgs.texlive) scheme-full latex-bin latexmk;

            latex-theme-ec = {
                pkgs = [ pkgs.latex-theme-ec pkgs.ec-square-sans-lualatex ];
            };
        };

        tex-for-ci = pkgs.texlive.combine {
            inherit (pkgs.texlive) scheme-full latex-bin latexmk;

            latex-theme-ec = {
                pkgs = [ pkgs.latex-theme-ec ];
            };
        };

        myaspell = pkgs.aspellWithDicts (d: [d.en d.en-science d.en-computers d.fr d.be]);

        pandoc-presentation = pkgs.stdenvNoCC.mkDerivation {
          name = "ec-pandoc-presentation";

          src = pkgs.lib.cleanSource ./.;

          buildInputs = [
            pandoc
            pkgs.gnumake
            pkgs.nodePackages.cspell
            myaspell
          ];

          buildPhase = ''
            make build-pandoc-presentation
          '';

          installPhase = ''
            runHook preInstall

            install -m644 -D *.pdf --target $out/

            runHook postInstall
          '';
        };
      in
      {
        packages.default = if ci-detector.lib.inCI then
            (pandoc-presentation.overrideAttrs (oldAttrs: {
                buildInputs = [ oldAttrs.buildInputs ] ++ [ tex-for-ci ];
            }))
        else
            (pandoc-presentation.overrideAttrs (oldAttrs: {
                buildInputs = [ oldAttrs.buildInputs ] ++ [ tex ];
            }));

        # Nix develop
        devShells.default = pkgs.mkShellNoCC {
          name = "ec-presentation-devshell";
          buildInputs = [
            tex
            pandoc
            pkgs.gnumake
            pkgs.nodePackages.cspell
            pkgs.nodePackages.prettier
            myaspell
            pkgs.inotify-tools
            pkgs.nixpkgs-fmt
            pkgs.nixfmt
          ];
        };
      });
}
