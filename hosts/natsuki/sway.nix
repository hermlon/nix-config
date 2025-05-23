{ config, pkgs, lib, ... }:

let
  # bash script to let dbus know about important env variables and
  # propagate them to relevent services run at the end of sway config
  # see
  # https://github.com/emersion/xdg-desktop-portal-wlr/wiki/"It-doesn't-work"-Troubleshooting-Checklist
  # note: this is pretty much the same as  /etc/sway/config.d/nixos.conf but also restarts  
  # some user services to make sure they have the correct environment variables
  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;

    text = ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
      systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
    '';
  };

  # currently, there is some friction between sway and gtk:
  # https://github.com/swaywm/sway/wiki/GTK-3-settings-on-Wayland
  # the suggested way to set gtk settings is with gsettings
  # for gsettings to work, we need to tell it where the schemas are
  # using the XDG_DATA_DIR environment variable
  # run at the end of sway config
  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;
    text = let
      schema = pkgs.gsettings-desktop-schemas;
      datadir = "${schema}/share/gsettings-schemas/${schema.name}";
    in ''
      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
      gnome_schema=org.gnome.desktop.interface
      gsettings set $gnome_schema gtk-theme 'Adwaita'
    '';
  };

in
{
  environment.systemPackages = with pkgs; [
    dbus-sway-environment
    configure-gtk
    wayland
    xdg-utils # for opening default programs when clicking links
    glib # gsettings
    adwaita-icon-theme  # default gnome cursors
    swaylock
    swayidle
    grim # screenshot functionality
    slurp # screenshot functionality
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    bemenu
    mako # notification system developed by swaywm maintainer
    wdisplays # tool to configure displays
    wob
    waybar
		libnotify
		file-roller
		pipewire
		pipewire.jack
		qpwgraph
  ];

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
		jack.enable = true;
  };

  # xdg-desktop-portal works by exposing a series of D-Bus interfaces
  # known as portals under a well-known name
  # (org.freedesktop.portal.Desktop) and object path
  # (/org/freedesktop/portal/desktop).
  # The portal interfaces include APIs for file access, opening URIs,
  # printing and others.
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # enable sway window manager
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  #pkgs.catppuccin-gtk.override = {
  #  accents = [ "pink" ]; # You can specify multiple accents here to output multiple themes
  #  size = "compact";
  #  tweaks = [ "rimless" "black" ]; # You can also specify multiple tweaks here
  #  variant = "macchiato";
  #};

  fonts.packages = with pkgs; [
		nerd-fonts.iosevka
		nerd-fonts.fira-code
		noto-fonts-monochrome-emoji
		#aegyptus
		fira
		inter
		roboto
  ];

  programs.light.enable = true;
  users.users.hermlon.extraGroups = [ "video" ];

	programs.thunar.enable = true;
	programs.thunar.plugins = with pkgs.xfce; [
		thunar-archive-plugin
	];

  programs.fish = {
    enable = true;
    loginShellInit = ''
		if test -n "$XDG_SESSION_TYPE"
			gnome-keyring-daemon --start > /dev/null
			for env_var in (gnome-keyring-daemon --start)
				set -x (echo $env_var | string split "=")
			end
			exec sway
		end
    '';
	};
	programs.dconf.enable = true;
	stylix.enable = true;
	stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/horizon-dark.yaml";
	stylix.cursor.name = "Adwaita";
	stylix.cursor.package = pkgs.adwaita-icon-theme;
	stylix.cursor.size = 22;

	networking.networkmanager.ensureProfiles.profiles = {
		"38C3" = {
			connection = {
				id = "38C3";
				type = "wifi";
				interface-name = "wlp3s0";
			};
			wifi = {
				mode = "infrastructure";
				ssid = "38C3";
			};
			wifi-security = {
				auth-alg = "open";
				key-mgmt = "wpa-eap";
			};
			"802-1x" = {
				anonymous-identity = "38C3";
				eap = "ttls;";
				identity = "38C3";
				password = "38C3";
				phase2-auth = "pap";
				altsubject-matches = "DNS:radius.c3noc.net";
				ca-cert = "${builtins.fetchurl {
					url = "https://letsencrypt.org/certs/isrgrootx1.pem";
					sha256 = "sha256:1la36n2f31j9s03v847ig6ny9lr875q3g7smnq33dcsmf2i5gd92";
				}}";
			};
			ipv4 = {
				method = "auto";
			};
			ipv6 = {
				addr-gen-mode = "default";
				method = "auto";
			};
		};
	};
}
