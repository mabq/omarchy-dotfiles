--[[

  REQUIREMENTS:

    Mason needs a few tools that it cannot install itself and are normally
    installed on Linux systems (otherwise you need to install those yourself
    using the system package manager).

    See the list in [requirements](https://github.com/mason-org/mason.nvim#requirements).

  NixOS:

    Some tools installed by Mason won't work in NixOS because they won't be
    able to find the expected dynamic libraries. You can make these tools work
    by enabling `nix-ld` or by installing the packages with Nix.

  EXPLANATION:

    mason.nvim:
      Is a portable package manager for Neovim that runs everywhere Neovim
      runs. Its main job is putting tools on disk and making those tools
      visible to Neovim's LSP client, shell, terminal, etc.

      It installs LSP servers, formatters and linters into
      `~/.local/share/nvim/mason/bin/` and adds that directory to Neovim's PATH
      — as any other process, Neovim inherits the environment variables from
      its parent process (the shell that launched it).

    mason-tool-installer:
      Is a helper plugin on top of `mason.nvim` that automatically installs and
      update Mason tools.

  COMMANDS:

    `:Mason` — check installed tools or install new ones manually

    `:checkhealth mason` - verify Mason requirements are met

    `:echo executable("<lsp-command>")` — check the binary is in Neovim's PATH,
    for example `:echo executable("lua-language-server")`.

    `:echo exepath("<command>")` — shows the path of the executable

    For all Mason commands, visit: https://github.com/mason-org/mason.nvim#commands

--]]

return {
  {
    "mason-org/mason.nvim",
    lazy = false, -- set up on startup so its bin directory is added to PATH
    opts = {},
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        -- Vim
        { "vim-language-server" },

        -- Lua
        { "lua-language-server" },
        { "stylua" },

        -- Bash
        { "bash-language-server" },
        { "shellcheck" },
        { "shfmt" },

        -- Javascript/css/html
        { "biome" },

        -- JSON
        { "json-lsp" },

        -- yaml
        { "yaml-language-server" },
        { "yamlfmt" },

        -- Nix
        { "nixfmt" },

        -- Tree-sitter-cli
        { "tree-sitter-cli" },
      },
      auto_update = false,
      run_on_start = true, -- install missing tools when Neovim starts
    },
  },
}
