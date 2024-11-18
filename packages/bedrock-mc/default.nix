{
  pkgs,
  lib,
  stdenv,
}:
with pkgs;
appimageTools.wrapType2 {
  name = "bedrock-mc";
  src = fetchurl {
    url = "https://github.com/minecraft-linux/appimage-builder/releases/download/v0.13.0-786/Minecraft_Bedrock_Launcher-x86_64-v0.13.0.786.AppImage";
    hash = "sha256-V8T9Mb9MvztaYhLHRFr5EENkoK7O40EFT+X08GF2HkA=";
  };
  extraPkgs = pkgs: with pkgs; [ openssl ];
}
