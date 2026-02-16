return {
  'MagicDuck/grug-far.nvim',
  keys = {
    {
      "<C-f>",
      function()
        require('grug-far').open({ transient = true })
      end
    },
    {
      "<C-f>",
      function()
        require('grug-far').with_visual_selection({ transient = true })
      end,
      mode = "v"
    }
  },
  -- Note (lazy loading): grug-far.lua defers all it's requires so it's lazy by default
  -- additional lazy config to defer loading is not really needed...
  config = function()
    -- optional setup call to override plugin options
    -- alternatively you can set options with vim.g.grug_far = { ... }
    require('grug-far').setup({
      -- options, see Configuration section below
      -- there are no required options atm
    });
    local group = vim.api.nvim_create_augroup("grug-far-keys", { clear = true })
    vim.api.nvim_create_autocmd('FileType', {
      group = group,
      pattern = { 'grug-far' },
      callback = function()
        vim.keymap.set('n', '<localleader>x', function()
          local state = unpack(require('grug-far').get_instance(0):toggle_flags({ '--fixed-strings' }))
          vim.notify('grug-far: toggled --fixed-strings ' .. (state and 'ON' or 'OFF'))
        end, { buffer = true })
      end,
    })
  end
}
