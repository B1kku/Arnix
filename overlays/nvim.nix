(final: prev: {
  neovim-unwrapped = prev.neovim-unwrapped.overrideAttrs (old: {
    version = "0.20.0";
    buildInputs = old.buildInputs ++ [ prev.pkgs.xclip ];
  });
  neovim = prev.neovim.overrideAttrs rec {
    # extra dependencies.
    extraPackages = with prev.pkgs; [ xclip ];
    extraMakeWrapperArgs =
      ''--suffix PATH : "${prev.lib.makeBinPath extraPackages}"'';
    wrapperArgs = extraMakeWrapperArgs;
  };
})
