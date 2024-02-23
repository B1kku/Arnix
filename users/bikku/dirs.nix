{ config, ... }: {
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    documents = "/run/media/bikku/Data-SSD/Documents/";
    download = "/run/media/bikku/Data-HDD/Downloads/";
  };
  home.file = {
    Documents.source =
      config.lib.file.mkOutOfStoreSymlink "${config.xdg.userDirs.documents}";
    Downloads.source =
      config.lib.file.mkOutOfStoreSymlink "${config.xdg.userDirs.download}";
  };
}
