{
	androidABIs ? [ "arm64-v8a" ],   # for Android SDK
	androidTarget ? "android-arm64", # for Flutter
	androidPlatforms ? [ "33" ],
	androidBuildToolsVersion ? "30.0.3",
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

	androidCompositionArgs = {
		platformVersions = androidPlatforms;
		abiVersions = androidABIs;
		systemImageTypes = [ "google_apis" ];
		buildToolsVersions = [ androidBuildToolsVersion "33.0.1" ];

		includeNDK = true;

		extraLicenses = [
			"android-googletv-license"
			"android-sdk-arm-dbt-license"
			"android-sdk-preview-license"
			"google-gdk-license"
			"mips-android-sysimage-license"
		];
	};

	androidComposition = androidEnv.composeAndroidPackages androidCompositionArgs;

	# Shell functions.

	withPlatform = platform: attr:
		if elem platform platforms then
			attr
		else
			{};
in

pkgs.mkShell rec {
	buildInputs = with pkgs; [
		flutter
		androidComposition.androidsdk
		gradle_7
		jdk17_headless
	];

	packages = with pkgs; [
		jq
	];

	CHROME_EXECUTABLE = "${pkgs.google-chrome}/bin/google-chrome-stable";
	ANDROID_SDK_ROOT = "${androidComposition.androidsdk}/libexec/android-sdk";
	GRADLE_OPTS = "-Dorg.gradle.project.android.aapt2FromMavenOverride=${ANDROID_SDK_ROOT}/build-tools/33.0.1/aapt2";

	passthru = {
		# For convenience.
		inherit androidComposition androidCompositionArgs;
	};
}
