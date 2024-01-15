local nix_path = os.getenv("NIX_PATH")
if (nix_path) then
  local nixos_config
  for str in string.gmatch(nix_path, "nixos%-config=(.*):") do
    if str then nixos_config = vim.fn.fnamemodify(str, ":p:h") end
  end

  vim.g.nixvars = {
    config_dir = nixos_config .. "/dotfiles/nvim/lazy-lock.json"
  }
end

