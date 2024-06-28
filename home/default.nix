{ config, pkgs, ... }:

{
	imports = [
	];

	gtk.cursorTheme.name = "Adwaita";
	gtk.cursorTheme.package = pkgs.gnome3.adwaita-icon-theme;
	gtk.iconTheme.name = "Tela-purple-dark";
	gtk.iconTheme.package = pkgs.tela-icon-theme;

	services.mpris-proxy.enable = true;

	home = {
		username = "hermlon";
		homeDirectory = "/home/hermlon";
		stateVersion = "23.11";
	};

	home.packages = with pkgs; [
		webcord
	];

	programs.home-manager.enable = true;
}
