local M = {}
M.settings = {
    Lua = {
        runtime = {
            version = "LuaJIT",
            path = vim.split(package.path, ";")
        },
        diagnostics = {
            globals = { "vim" },
        },
        workspace = {
            -- library = vim.api.nvim_get_runtime_file("", true),
            library = {
                vim.api.nvim_get_runtime_file("", true),
                -- [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                -- [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
            },
            -- adjust these two values if your performance is not optimal
            maxPreload = 2000,
            preloadFileSize = 1000,
            checkThirdParty = false
        },
        telemetry = { enable = false },
    }
}
return M
