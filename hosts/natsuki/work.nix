{ config, pkgs, lib, ... }:

{
	programs.nix-ld.enable = true;

	programs.java = {
		enable = true;
		package = pkgs.jdk17;
	};

	services.udev.packages = [
    pkgs.android-udev-rules
  ];
	users.users.hermlon.extraGroups = ["adbusers"];
	users.users.hermlon.packages = with pkgs; [
		azure-cli
		kubectl
		kubernetes-helm
		kubelogin
		dbeaver-bin
		socat
		jetbrains.rider
		dotnet-sdk_8
		openlens
		yarn
		android-studio

		zoom-us
	];
}
