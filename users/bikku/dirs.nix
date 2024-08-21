{ config, ... }:
let media = "/run/media/bikku/";
in {
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    documents = media + "Data-SSD/Documents/";
    download = media + "Data-HDD/Downloads/";
  };
  home.file = let
    inherit (config.lib.file) mkOutOfStoreSymlink;
    inherit (config.xdg.userDirs) documents download;
  in {
    Documents.source = mkOutOfStoreSymlink "${documents}";
    Downloads.source = mkOutOfStoreSymlink "${download}";
    Games.source = mkOutOfStoreSymlink (media + "Data-SSD/Games-SSD/Prefixes/");
    OPsidian.source =
      mkOutOfStoreSymlink (documents + "Coding/OPsidian/");
    Greenbeania.source = 
      mkOutOfStoreSymlink (documents + "Coding/Greenbeania/");
  };
}
