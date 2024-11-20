{ config, pkgs, lib, ... }:

{
	imports = [
	];

	gtk.iconTheme.name = "Tela-purple-dark";
	gtk.iconTheme.package = pkgs.tela-icon-theme;

	services.mpris-proxy.enable = true;

	home = {
		username = "hermlon";
		homeDirectory = "/home/hermlon";
		stateVersion = "24.11";
	};

	home.packages = with pkgs; [
		webcord
	];

	programs.home-manager.enable = true;
}
