# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{config, pkgs, ...}: 
{ 
  
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  
  nixpkgs.config.allowUnfree = true;  
  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only
  environment.variables = {
	"MESA_LOADER_DRIVER_OVERRIDE" = "crocus";
  };
  networking.hostName = "Yui"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  #OpenGL
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.extraPackages = with pkgs; [
	vaapiIntel
	libvdpau-va-gl
  ];
  
  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Enable the X11 windowing system.
  #services.xserver.enable = true;
  fonts.fonts = with pkgs; [
	(nerdfonts.override { fonts = [ "CascadiaCode" ]; })
        noto-fonts
        noto-fonts-cjk
        liberation_ttf
  ];  
  #defaultUserShell = pkgs.nushell; 
  # Configure keymap in X11
  services.xserver.layout = "us";
  # services.xserver.xkbOptions = {
  #   "eurosign:e";
  #   "caps:escape" # map caps to escape.
  # };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  #sound.enable = true;
  #hardware.pulseaudio.enable = true;
    #Pipewire
  security.rtkit.enable = true;
  services.pipewire = {
     enable = true;
     alsa.enable = true;
     alsa.support32Bit = true;
     pulse.enable = true;
  };
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
   nixpkgs.overlays = [ 
    (self: super: { 
    jona-picom = super.picom.overrideAttrs (old: rec { 
      pname = "jona-picom"; 
      version = "git"; 
      src = super.fetchFromGitHub { 
        owner = "jonaburg"; 
        repo = "picom"; 
        rev = "e3c19cd7d1108d114552267f302548c113278d45"; 
        sha256 = "sha256-4voCAYd0fzJHQjJo4x3RoWz5l3JJbRvgIXn1Kg6nz6Y"; # TODO 
       }; 
     }); 
   }) 
  ];
  #Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.hikari = {
     isNormalUser = true;
     extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
     packages = with pkgs; [
       firefox
       neofetch
       pkgs.jona-picom
     ];
       shell = pkgs.nushell;
   };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     vim 
     wget
     xorg.xf86videointel
     bspwm
     sxhkd
     scrot
     kitty
     rofi
     polybar
     cava
     feh
     unrar
     unzip
     ranger
     git
     pamixer
     pulseaudio 
     neovim
     btop
     pipes
     pfetch
     nushell
     mesa
     eww 
     ani-cli
   ];
  
  services.xserver.enable = true;
  services.xserver.windowManager.bspwm.enable = true;
  
  services.xserver.displayManager.defaultSession = "none+bspwm";

  services.picom  = {
	enable = true;
	settings.activeOpacity = "0.80";
        settings.blur = true;
        settings.extraOptions = '' 
		corner-radius = 10;
		round-borders = 1;
		blur-method = "dual_kawase";
		blur-strength = "10";
		xinerama-shadow-crop = true;
	'';
	experimentalBackends = true;
	fade = true;
	fadeDelta = 10;
       
	vSync = true;
	settings.opacityRule = [
		"100:class_g *?= 'firefox'"
		"80:class_g *?= 'kitty'"

	];
        settings.package = "jona-picom";
   };
   

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
   programs.mtr.enable = true;
   programs.gnupg.agent = {
      enable = true;
     enableSSHSupport = true;
   };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.forwardX11  = true;
  #  services.openssh.setXAuthLocation = true;
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}
