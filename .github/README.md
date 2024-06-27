# NixOS configuration - WIP

> [!NOTE]
> This repository contains my NixOS configuration files. I'm still learning NixOS, so this repository is a work in progress. Contains NVIDIA drivers, Hyprland WM (wayland), Virtualization, and more.


> [!CAUTION]
> :warning: Make sure to backup your existing configuration files before proceeding with the installation. Modifying your NixOS configuration can have unintended consequences and may render your system unusable if not done correctly. It is recommended to test any changes in a virtual machine or non-production environment first.

Once you are ready, run the following command to apply the configuration changes:
```sh
sudo nixos-rebuild switch --flake .
```

For more information on NixOS configuration, refer to the [official documentation](https://nixos.org/manual/).

