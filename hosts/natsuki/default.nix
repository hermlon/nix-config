# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
			./sway.nix
			./work.nix
    ];

	nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
	boot.initrd.kernelModules = [ "i915" ];

	boot.tmp.cleanOnBoot = true;

  networking.hostName = "natsuki"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

	nix.gc = {
		automatic = true;
		dates = "weekly";
		options = "--delete-older-than 30d";
	};

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  #services.xserver.enable = true;


  # Enable the Plasma 5 Desktop Environment.
  #services.xserver.displayManager.sddm.enable = true;
  #services.xserver.desktopManager.plasma5.enable = true;
  

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  services.printing.enable = true;
	services.printing.drivers = [	pkgs.mfcl3770cdwcupswrapper ];

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

	hardware.bluetooth = {
		enable = true;
		powerOnBoot = true;
	};

	services.blueman.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.hermlon = {
    isNormalUser = true;
    initialPassword = "password";
    shell = pkgs.fish;
    extraGroups = [ "wheel" "networkmanager" "disk" "dialout" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      git
			git-lfs
      firefox
      tree
			neovim
			tmux
			curl
			wget
			foot
			thunderbird
			acpi
			signal-desktop
			element-desktop
			nextcloud-client
			vscodium-fhs
			pamixer
			pulseaudio
			htop
			keepassxc
			neofetch
			chromium
			libreoffice-fresh
			system-config-printer
			nmap
			zathura
			xfce.thunar
			imagemagick
			downonspot
			mpv
			_0x
			font-manager
			pavucontrol
			difftastic
			gcc
			cmake
			gnumake
			restic
			rclone
			wireguard-tools
			typst
			elixir
			inotify-tools
			unzip
			imv
			gimp
			inkscape
			lxqt.lxqt-policykit # required for thunar with gvfs
			picocom
			screen
			xournalpp
			pdfarranger
			geeqie
			transmission_4-gtk
			gnome.seahorse
			neovide
			easyeffects
			iamb
			nodejs
			wineWowPackages.waylandFull
			winetricks
			wineasio
			yt-dlp
			ffmpeg
			syncplay
			openssl
			parted
			hunspellDicts.de_DE
			hunspellDicts.en_US
			ncdu
			texlive.combined.scheme-full
			gummi
			mitmproxy
			godot_4
			obsidian
			jq
			bluez
			watson
			zbar
			wev
			python311
			cotp
			podman-compose
    ] ++ 
		[
			inputs.dune3d.packages.${pkgs.system}.default
			inputs.papis.packages.${pkgs.system}.default
		];
  };

	nixpkgs.config.permittedInsecurePackages = [
		"electron-25.9.0" # for obsidian
	];

	services.gnome.gnome-keyring.enable = true;
	services.getty.extraArgs = [ "--skip-login" ];
	services.getty.loginOptions = "-p -- hermlon";

	services.gvfs.enable = true;

	programs.git = {
		enable = true;
		package = pkgs.gitFull;
		config.credential.helper = "libsecret";
	};

	programs.neovim = {
		enable = true;
		defaultEditor = true;
	};

	virtualisation.containers.enable = true;
	virtualisation.podman = {
		enable = true;
		dockerCompat = true;
		defaultNetwork.settings.dns_enabled = true;
	};

	boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # environment.systemPackages = with pkgs; [
  #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #   wget
  # ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  #services.openssh.enable = true;

  services.logind.extraConfig = ''
    HandlePowerKey=suspend
    HandleLidSwitch=ignore
    HandleLidSwitchExternalPower=ignore
    HandleLidSwitchDocked=ignore
  '';

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?

}

