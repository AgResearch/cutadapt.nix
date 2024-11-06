{
  description = "Flake for cutadapt which removes adapter sequences from sequencing reads";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
          };

          dnaio =
            let
              version = "1.2.2";
              hash = "sha256-tnF6L75uv5j7ZEENFBPWujSz41ihJdylzgEFRir4p/k=";

              inherit (pkgs) fetchFromGitHub python3Packages;
            in
            with python3Packages;
            buildPythonPackage rec {
              pname = "dnaio";
              inherit version;
              pyproject = true;

              src = fetchFromGitHub {
                owner = "marcelm";
                repo = "dnaio";
                rev = "v${version}";
                inherit hash;
              };

              build-system = [
                setuptools
                setuptools_scm
              ];

              dependencies = [
                cython
                xopen
              ];
            };

          xopen =
            let
              version = "2.0.2";
              hash = "sha256-E2OggeShagKzRD4Aa7pk90CDD1QBqZvSd+q7xHldI/U=";

              inherit (pkgs) fetchFromGitHub python3Packages;
            in
            with python3Packages;
            buildPythonPackage rec {
              pname = "xopen";
              inherit version;
              pyproject = true;

              src = fetchFromGitHub {
                owner = "marcelm";
                repo = "xopen";
                rev = "v${version}";
                inherit hash;
              };

              build-system = [
                setuptools
                setuptools_scm
              ];

              dependencies = [
                isal
                zlib-ng
              ];
            };

          cutadapt =
            let
              version = "4.9";
              hash = "sha256-38CfBNDRGtYVOCdR3Q84o68UJPjdEKyYuvpIbbYaSSw=";

              inherit (pkgs) fetchFromGitHub python3Packages;
            in
            with python3Packages;
            buildPythonApplication rec {
              pname = "cutadapt";
              inherit version;
              pyproject = true;

              src = fetchFromGitHub {
                owner = "marcelm";
                repo = "cutadapt";
                rev = "v${version}";
                inherit hash;
              };

              build-system = [
                setuptools
                setuptools_scm
              ];

              dependencies = [
                cython
                dnaio
                xopen
              ];
            };

        in
        with pkgs;
        {
          devShells = {
            default = mkShell {
              buildInputs = [ cutadapt ];
            };
          };
          packages = {
            default = cutadapt;
          };
        }
      );
}

