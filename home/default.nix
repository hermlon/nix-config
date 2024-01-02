{ config, pkgs, ... }:

{
	imports = [
	];

	gtk.cursorTheme.name = "Adwaita";
	gtk.cursorTheme.package = pkgs.gnome3.adwaita-icon-theme;

	home = {
		username = "hermlon";
		homeDirectory = "/home/hermlon";
		stateVersion = "23.11";
	};

	programs.home-manager.enable = true;
}
