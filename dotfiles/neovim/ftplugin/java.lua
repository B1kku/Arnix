local jdtls_ok = pcall(require, "jdtls")
if not jdtls_ok then
  vim.notify "JDTLS not found, install with `:MasonInstall jdtls`"
  return
end

-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
local root_dir = require("jdtls.setup").find_root(root_markers)
if root_dir == "" then
  return
end
-- calculate workspace dir
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = vim.fn.stdpath("data") .. "/site/java/workspace-root/" .. project_name
os.execute("mkdir " .. workspace_dir)

local extendedClientCapabilities = require("jdtls").extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

-- get the mason install path
local install_path = require("mason-registry").get_package("jdtls"):get_install_path()

-- get the current OS
local os
if vim.fn.has "macunix" then
  os = "mac"
elseif vim.fn.has "win32" then
  os = "win"
else
  os = "linux"
end


-- Main Config
local config = {
  -- The command that starts the language server
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  cmd = {
    "java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-javaagent:" .. install_path .. "/lombok.jar",
    "-Xms1g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",
    "-jar", vim.fn.glob(install_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
    "-configuration", install_path .. "/config_" .. os,
    "-data", workspace_dir,
  },
  -- One dedicated LSP server & client will be started per unique root_dir
  root_dir = root_dir,
  settings = {
    java = {
      --
      -- jdt = {
      --   ls = {
      --     vmargs = "-XX:+UseParallelGC -XX:GCTimeRatio=4 -XX:AdaptiveSizePolicyWeight=90 -Dsun.zip.disableMemoryMapping=true -Xmx1G -Xms100m"
      --   }
      -- },
      --
      eclipse = {
        downloadSources = true,
      },
      -- configuration = {
      --   updateBuildConfiguration = "automatic", -- This doesn't seem to work I assume it's cause we're only attaching to java files.
      --   --
      --   -- runtimes = {
      --   --   {
      --   --     name = "JavaSE-17",
      --   --     path = "/home/jrakhman/.sdkman/candidates/java/17.0.4-oracle",
      --   --   },
      --   -- },
      --   --
      -- },
      maven = {
        downloadSources = true,
      },
      implementationsCodeLens = {
        enabled = true,
      },
      referencesCodeLens = {
        enabled = true,
      },
      references = {
        includeDecompiledSources = true,
      },
      inlayHints = {
        parameterNames = {
          enabled = "all", -- literals, all, none
        },
      },
      format = {
        enabled = true,
        settings = {
          url = install_path .. "/eclipse-java-google-style.xml",
          profile = "GoogleStyle"
        }
      }
    },
    signatureHelp = { enabled = true },
    completion = {
      favoriteStaticMembers = {
        "org.hamcrest.MatcherAssert.assertThat",
        "org.hamcrest.Matchers.*",
        "org.hamcrest.CoreMatchers.*",
        "org.junit.jupiter.api.Assertions.*",
        "java.util.Objects.requireNonNull",
        "java.util.Objects.requireNonNullElse",
        "org.mockito.Mockito.*",
      }
    },
    contentProvider = { preferred = "fernflower" },
    extendedClientCapabilities = extendedClientCapabilities,
    sources = {
      organizeImports = {
        starThreshold = 5,
        staticStarThreshold = 5,
      }
    },
    codeGeneration = {
      toString = {
        template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
      },
      useBlocks = true,
    }
  },
  flags = {
    allow_incremental_sync = true,
  },
  init_options = {
    bundles = {},
  },
}

-- config["on_attach"] = function(client, bufnr)
--   require"keymaps".map_java_keys(bufnr);
--   require "lsp_signature".on_attach({
--     bind = true, -- This is mandatory, otherwise border config won"t get registered.
--     floating_window_above_cur_line = false,
--     padding = "",
--     handler_opts = {
--       border = "rounded"
--     }
--   }, bufnr)
-- end
--
-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
require("jdtls").start_or_attach(config)
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.gradle",
  group = vim.api.nvim_create_augroup('refresh_gradle', { clear = true }),
  command = "JdtUpdateConfig"
})
