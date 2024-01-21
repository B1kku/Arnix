final: prev: {
  jdtls = final.callPackage ../packages/jdtls { };
  gnomeExtensions = prev.gnomeExtensions // {
    valent = prev.gnomeExtensions.valent.overrideAttrs (old: {
      src = prev.fetchFromGitHub {
        owner = "andyholmes";
        repo = "gnome-shell-extension-valent";
        rev = "449bb36f1019ac09b06aad6c12deffcc4f317738";
        hash = "sha256-jm+TYqgCalFgjJf0CJ2poFa1W0OS192DVI7DOxjEY+g=";
      };
    });
  };

}
