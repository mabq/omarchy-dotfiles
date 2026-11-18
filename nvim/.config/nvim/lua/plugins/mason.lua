-- Mason is a package manager for Neovim that installs LSP servers, formatters,
-- linters and other tools into Neovim's data directory, instead of relying on
-- the system package manager. This makes the configuration portable between
-- operating systems and distributions.
--
-- Mason prepends its `bin/` directory to Neovim's PATH, so every tool it
-- installs is available to LSP clients, Conform and terminal buffers without
-- any extra configuration.
--
-- Mason still needs a few tools that it cannot install itself:
--   git, curl (or wget), unzip, tar, gzip  to download and unpack packages
--   node/npm                               for packages installed from npm
--   gcc or clang                           to compile tree-sitter parsers
-- Check `:checkhealth mason` for the full list.
--
-- On NixOS, Mason's prebuilt binaries may not run unless nix-ld is enabled.
-- In that case keep installing those tools with Nix (see `_packages.nix`).

return {
  -- The package manager --------------------------------------------------------
  {
    "mason-org/mason.nvim",
    lazy = false, -- set up on startup so its bin directory is added to PATH
    opts = {},
  },

  -- Bridge between Mason and nvim-lspconfig ------------------------------------
  --   Installs servers using their lspconfig names and enables (`vim.lsp.enable`)
  --   every server installed by Mason.
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      -- Servers to install automatically on startup.
      -- `:LspInstall` installs any other server on demand.
      ensure_installed = {
        "bashls", -- bash-language-server
        "jsonls", -- vscode-json-language-server
        "lua_ls", -- lua-language-server
      },

      -- `automatic_enable` enables every server that is installed by Mason.
      -- Some packages installed here for formatting (`biome` and `stylua`) also
      -- ship an LSP server, so exclude them to avoid attaching clients that
      -- this config does not intend to run. Servers that are not in the Mason
      -- registry (mise and nixd) are enabled manually in `lua/plugins/lsp.lua`.
      automatic_enable = {
        exclude = { "biome", "stylua" },
      },
    },
  },

  -- Declarative installation of tools that are not LSP servers ---------------
  --   Formatters used by Conform and the linter used by bashls.
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = {
        "biome", -- css, javascript, json, jsonc, markdown, typescript
        "nixfmt", -- nix
        "shellcheck", -- bashls diagnostics
        "shfmt", -- sh
        "stylua", -- lua
        "tree-sitter-cli", -- parser compilation for nvim-treesitter
      },
      run_on_start = true, -- install missing tools when Neovim starts
    },
  },
}

--[[

Commands:
  `:Mason` - open the Mason UI (install, update, uninstall)
  `:MasonInstall <package>` / `:MasonUninstall <package>`
  `:LspInstall <server>` - install a language server by lspconfig name
  `:MasonToolsInstall` - install the tools listed in `ensure_installed`
  `:MasonToolsUpdate` - install missing tools and update the installed ones

Verify:
  `:checkhealth mason`
  `:MasonLog` - installation log

Find package names:
  https://mason-registry.dev/registry/list
  `:h mason.nvim`

--]]
