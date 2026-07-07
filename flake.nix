{
  description = "TrapNouz NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    thyx.url = "github:rccyx/thyx";

    home-manager = {                                          
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

      helium = {
  url = "github:schembriaiden/helium-browser-nix-flake";
  inputs.nixpkgs.follows = "nixpkgs";
};

    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
  };

  outputs = { self, nixpkgs, thyx, home-manager, nix-cachyos-kernel, helium, }@ inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {

     system = "x86_64-linux";
      specialArgs = { inherit inputs;nix-cachyos-kernel = inputs.nix-cachyos-kernel; };
      modules = [
        ./configuration.nix
         home-manager.nixosModules.home-manager
         thyx.nixosModules.default
      ];
    };
  };
}
