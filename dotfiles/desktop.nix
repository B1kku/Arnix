{
  pkgs,
  ...
}:
let
  icon-theme = {
    package = pkgs.papirus-icon-theme;
    name = "Papirus-Dark";
  };
in
{
  qt = {
    enable = true;
    style.name = "adwaita-dark";
  };
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
  };
  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    gtk.enable = true;
    size = 24;
  };

  # Icon theme generation.
  home.file = {
    ${icon-theme.name} = {
      source = "${icon-theme.package}/share/icons/${icon-theme.name}";
      target = ".icons/${icon-theme.name}";
    };
  };
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      icon-theme = icon-theme.name;
      color-scheme = "prefer-dark";
    };
  };
}
