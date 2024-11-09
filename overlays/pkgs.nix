final: prev: {
  kotlin-language-server = prev.kotlin-language-server.overrideAttrs (oldAttrs: rec {
    version = "1.3.12";
    src = prev.fetchzip {
      url = "https://github.com/fwcd/kotlin-language-server/releases/download/${version}/server.zip";
      hash = "sha256-poWaU0vZS1cpMbbvN7/s1RRUKhekdfTi08fF/IZsVGs=";
    };
  });
  # bedrock-mc = final.callPackage ../packages/bedrock-mc { };
  # # Also should be removed on update, but didn't see any PR for updating this?
  # gnomeExtensions = prev.gnomeExtensions // {
  #   taskwhisperer = prev.gnomeExtensions.taskwhisperer.overrideAttrs (old: {
  #     src = prev.fetchFromGitHub {
  #       owner = "cinatic";
  #       repo = "taskwhisperer";
  #       rev = "79307d385f81e9d7a5d822f72fff74f50c96ceba";
  #       hash = "sha256-zWCzGVHVBZqwheT4k9XTBs1OqoWzHRe/RA6Ws2kIuoQ=";
  #     };
  #     nativeBuildInputs = with prev; [ gettext glib ];
  #     patches = [ ];
  #   });
  # };
}
