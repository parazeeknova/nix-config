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
      	hostname = "nixpewpew"; # hostname
      	system = "x86_64-linux"; # system arch
      	timezone = "Asia/Kolkata"; # select timezone
      	locale = "en_IN"; # select locale 
      };

      # --- USER SETTINGS --- #
      userSettings = rec {
      username = "pewpew"; # username 
      name = "parazeeknova"; # name/identifier
      dotfilesDir = "~/.dotfiles"; # absolute path of the local repo 
      };
      
      # Package repository
      pkgs = nixpkgs.legacyPackages.${systemSettings.system};
      pkgs-unstable = nixpkgs-unstable.legacyPackages.${systemSettings.system};
    in {  
      nixosConfigurations = {
        ${systemSettings.hostname} = lib.nixosSystem {
          system = systemSettings.system;
          modules = [ ./configuration.nix ];
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
          modules = [ ./home.nix ];
          extraSpecialArgs = {
            # pass config variables from above
            inherit userSettings;
            inherit systemSettings;
	    inherit pkgs-unstable;
          };
        };
      };
    };
}

