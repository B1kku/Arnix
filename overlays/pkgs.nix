final: prev: {
  bedrock-mc = final.callPackage ../packages/bedrock-mc { };
  # Also should be removed on update, but didn't see any PR for updating this?
  gnomeExtensions = prev.gnomeExtensions // {
    valent = prev.gnomeExtensions.valent.overrideAttrs (old: {
      src = prev.fetchFromGitHub {
        owner = "andyholmes";
        repo = "gnome-shell-extension-valent";
        rev = "449bb36f1019ac09b06aad6c12deffcc4f317738";
        hash = "sha256-jm+TYqgCalFgjJf0CJ2poFa1W0OS192DVI7DOxjEY+g=";
      };
    });
    taskwhisperer = prev.gnomeExtensions.taskwhisperer.overrideAttrs (old: {
      src = prev.fetchFromGitHub {
        owner = "cinatic";
        repo = "taskwhisperer";
        rev = "79307d385f81e9d7a5d822f72fff74f50c96ceba";
        hash = "sha256-zWCzGVHVBZqwheT4k9XTBs1OqoWzHRe/RA6Ws2kIuoQ=";
      };
      nativeBuildInputs = with prev; [ gettext glib ];
      patches = [ ];
    });
  };

}
