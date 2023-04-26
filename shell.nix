{
	platforms ? [ "web" "android" ],
	androidABIs ? [ "arm64-v8a" ],   # for Android SDK
	androidTarget ? "android-arm64", # for Flutter
	androidPlatforms ? [ "33" ],
}:

with builtins;

let
	systemPkgs = import <nixpkgs> {};
	lib = systemPkgs.lib;

	pkgs' = systemPkgs.fetchFromGitHub {
		owner = "NixOS";
		repo = "nixpkgs";
		rev = "6c43a3495a1"; # tracking unstable
		sha256 = "16f329z831bq7l3wn1dfvbkh95l2gcggdwn6rk3cisdmv2aa3189";
	};

	pkgs = import pkgs' {
		config = {
			# Accept the SDK license for androidsdk_9_0.
			android_sdk.accept_license = true;
			allowUnfree = true;
		};
	};

	# Flutter stuff.

	pkgsForFlutter' = pkgs.fetchFromGitHub {
		owner = "NixOS";
		repo = "nixpkgs";
		rev = "c3797393b70ce507aa47abb2f742bbb355e2c398";
		sha256 = "0lwhzq42hg4c0jarszz8irjgcgvkxcp2c4qhikczq6clpgj147m6";
	};

	flutterPackages = pkgs.callPackage "${pkgsForFlutter'}/pkgs/development/compilers/flutter" (
		let	pkgs = import pkgsForFlutter' {};
		in	{ inherit (pkgs.flutterPackages.stable) dart; }
	);

	flutter = flutterPackages.stable;

	# Android junk.
	# Refer to https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/mobile/androidenv/examples/shell-with-emulator.nix.

	androidEnv = pkgs.callPackage "${pkgs'}/pkgs/development/mobile/androidenv" {
		inherit pkgs;
		inherit (pkgs) config;
		licenseAccepted = true;
	};

	androidComposition = androidEnv.composeAndroidPackages {
		platformVersions = androidPlatforms;
		abiVersions = androidABIs;
		systemImageTypes = [ "google_apis" ];

		includeSystemImages = false;
		includeEmulator = false;

		extraLicenses = [
			"android-googletv-license"
			"android-sdk-arm-dbt-license"
			"android-sdk-preview-license"
			"google-gdk-license"
			"mips-android-sysimage-license"
		];
	};

	androidSDK = androidComposition.androidsdk;

	# Shell functions.

	withPlatform = platform: attr:
		if elem platform platforms then
			attr
		else
			{};

	shell = {
		buildInputs = [ flutter pkgs.jdk ];
	}
	// (withPlatform "web" {
		CHROME_EXECUTABLE = "${pkgs.google-chrome}/bin/google-chrome-stable";
	})
	// (withPlatform "android" {
		ANDROID_SDK_ROOT = "${androidSDK}/libexec/android-sdk";
	});
in

pkgs.mkShell shell
