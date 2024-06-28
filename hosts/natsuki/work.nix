{ config, pkgs, lib, ... }:

{
	programs.nix-ld.enable = true;

	users.users.hermlon.packages = with pkgs; [
		azure-cli
		kubectl
		kubernetes-helm
		kubelogin
		dbeaver-bin
		socat
		jetbrains.rider
		dotnet-sdk_8

		zoom-us
	];
}
