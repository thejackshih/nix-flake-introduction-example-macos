{
  description = "A flake for Hello World";

  # NOTE(Jack): Using default nixpkgs instead.
  # inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-20.03;
  outputs = { self, nixpkgs }: {
    defaultPackage.x86_64-linux =
      # Notice the reference to nixpkgs here.
      with import nixpkgs { system = "x86_64-linux"; };
      stdenv.mkDerivation {
        name = "hello";
        src = self;
        buildPhase = "gcc -o hello ./hello.c";
        installPhase = "mkdir -p $out/bin; install -t $out/bin hello";
      };
    defaultPackage.aarch64-darwin =
      with import nixpkgs { system = "aarch64-darwin"; };
      stdenv.mkDerivation {
        name = "hello";
        src = self;
        # NOTE(Jack): macOS doesn't have gcc.
        buildInputs = [
          gcc
        ];
        buildPhase = "gcc -o hello ./hello.c";
        installPhase = "mkdir -p $out/bin; install -t $out/bin hello";
      };
  };
}
