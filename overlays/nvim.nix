(final: prev: {
  neovim = final.neovim.override {
    buildInputs = pkgs: with pkgs; [
      fzf
      xclip
    ];
  };
})
