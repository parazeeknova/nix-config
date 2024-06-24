{ config, pkgs, ...}: 

{
  # Remove Gnome default application 
  environment.gnome.excludePackages = with pkgs.gnome; [
    baobab      # disk usage analyzer
    cheese      # photo booth
    # eog         # image viewer
    epiphany    # web browser
    pkgs.gedit       # text editor
    simple-scan # document scanner
    totem       # video player
    yelp        # help viewer
    evince      # document viewer
    file-roller # archive manager
    geary       # email client
    # seahorse    # password manager
    pkgs.snapshot # camera
    pkgs.gnome-tour # tour app

    # these should be self explanatory
    gnome-calculator gnome-calendar gnome-characters gnome-clocks gnome-contacts
    gnome-font-viewer gnome-logs gnome-maps gnome-music gnome-screenshot
    gnome-system-monitor gnome-weather gnome-disk-utility pkgs.gnome-connections
  ];

  # Disabling some gnome services 
  services.gnome.gnome-remote-desktop.enable = false;
  services.gnome.tracker.enable = false;
  services.system-config-printer.enable = false;

  # Remove xterm
  services.xserver.excludePackages = [ pkgs.xterm ];

}
