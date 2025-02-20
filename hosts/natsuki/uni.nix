{ config, pkgs, lib, ... }:

{
	users.users.hermlon.packages = with pkgs; [
		sshfs

		wineWowPackages.stable
		winetricks

		remmina
		virtualbox

		zotero_7
		stm32cubemx
	];
}
