{
  description = "My Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    xremap-flake = {
      url = "github:xremap/nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvim-spring-boot = {
      url = "github:JavaHello/spring-boot.nvim";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        ./configuration.nix
        inputs.xremap-flake.nixosModules.default
        ./services/xremap.nix
        #./local.dns.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.users.fady = import ./home.nix;
          home-manager.extraSpecialArgs = {inherit inputs;};
          # do this if you don't want to pass all inputs to home.nix
          #home-manager.sharedModules = [
          #inputs.xremap-flake.homeManagerModules.default
          #];
        }
        {nix.registry.nixpkgs.flake = nixpkgs;}
      ];
    };
  };
}
