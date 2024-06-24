{
  description = "Flakes for Hyprland chan ~";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:danth/stylix";
    fine-cmdline = {
      url = "github:VonHeikemen/fine-cmdline.nvim";
      flake = false;
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }@inputs:
    let

      # --- SYSTEM SETTINGS --- #
      systemSettings = {
      	hostname = "nixgoesbrrr"; # hostname
      	system = "x86_64-linux"; # system arch
      	timezone = "Asia/Kolkata"; # select timezone
      	locale = "en_IN"; # select locale 
      };

      # --- USER SETTINGS --- #
      userSettings = {
      username = "pewpew"; # username 
      name = "parazeeknova"; # name/identifier
      };
  
    in
    {
      nixosConfigurations = {
        "${systemSettings.hostname}" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit systemSettings;
            inherit inputs;
            inherit userSettings;
          };
          modules = [
            ./hosts/${systemSettings.hostname}/config.nix
            inputs.stylix.nixosModules.stylix
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = {
                inherit userSettings;
                inherit inputs;
                inherit systemSettings;
              };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.users.${userSettings.username} = import ./hosts/${systemSettings.hostname}/home.nix;
            }
          ];
        };
      };
    };
}
