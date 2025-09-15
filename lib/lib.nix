(
  final: prev:
  let
    lib = prev.lib;
  in
  {
    # Things will be placed under 'extra' namespace to clarify what's part of my domain and what comes from nixpkgs.
    extra = {
      print = x: lib.trace x x;
      getCachesFromInputs =
        inputs: caches:
        let
          checked-caches =
            caches
            |> lib.attrNames
            |> lib.map (
              input-name:
              assert lib.assertMsg (builtins.hasAttr input-name inputs)
                "${input-name} was present in the cache, but it's not on the inputs";
              input-name
            )
            |> (_: caches);
        in
        checked-caches
        |> builtins.attrValues
        |>
          builtins.foldl'
            (acc: cache: {
              substituters = cache.substituters ++ acc.substituters;
              trusted-public-keys = cache.trusted-public-keys ++ acc.trusted-public-keys;
            })
            {
              substituters = [ ];
              trusted-public-keys = [ ];
            };
    };
  }
)
