(final: prev: {
  neovim-unwrapped = prev.neovim-unwrapped.overrideAttrs (old: { 
    buildInputs = old.buildInputs ++ [prev.xclip];
  });
})
