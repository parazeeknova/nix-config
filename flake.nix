{
  description = "Flake for my configuration";
  
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs,nixpkgs-unstable, home-manager, ...}: 
    let 
      lib = nixpkgs.lib;

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
      dotfilesDir = "~/nix-config"; # absolute path of the local repo 
      };
      
      # Package repository
      pkgs = nixpkgs.legacyPackages.${systemSettings.system};
      pkgs-unstable = nixpkgs-unstable.legacyPackages.${systemSettings.system};
    in {  
      nixosConfigurations = {
        ${systemSettings.hostname} = lib.nixosSystem {
          system = systemSettings.system;
          modules = [ ./user/config.nix ];
          specialArgs = {
            # pass config variables form above
            inherit userSettings;
            inherit systemSettings;
	    inherit pkgs-unstable;
          };
        };
      };

      homeConfigurations = {
        ${userSettings.username} = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./user/home.nix ];
          extraSpecialArgs = {
            # pass config variables from above
            inherit userSettings;
            inherit systemSettings;
	    inherit pkgs-unstable;
          };
	  home-manager.useGlobalPkgs = true;
	  home-manager.useUserPackages = true;
	  home-manager.backupFileExtension = "backup";
	  home-manager.users.${userSettings.username} = import ./user/home.nix;
        };
      };
    };
}

