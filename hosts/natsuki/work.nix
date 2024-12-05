{ config, pkgs, lib, ... }:

{
	programs.nix-ld.enable = true;

#	programs.java = {
#		enable = true;
#		package = pkgs.jdk17;
#	};

	environment.sessionVariables = {
		DOTNET_ROOT = "${pkgs.dotnet-sdk_8}";
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
		lens
		yarn
		android-studio
		mosquitto

		zoom-us
	];

	nixpkgs.config = {
    android_sdk.accept_license = true;
    allowUnfree = true;
  };
  environment.systemPackages = with pkgs; [
    (pkgs.androidenv.emulateApp {
      name = "android_emulator";
      platformVersion = "35";
      abiVersion = "x86_64";
      systemImageType = "google_apis_playstore";
    })
  ];
}
