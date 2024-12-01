(final: prev: {
  # Things will be placed under 'extra' namespace to clarify what's part of my domain and what comes from nixpkgs.
  extra = {
    print = (x: prev.lib.trace x x);
  };
})
