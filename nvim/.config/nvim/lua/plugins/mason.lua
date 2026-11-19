--[[

  REQUIREMENTS:

    Mason still needs a few tools that it cannot install itself and are
    normally installed on Linux systems (otherwise you need to install those
    yourself using the system package manager):

      `git`, `curl`, `unzip`, `tar` and `gzip` to download and unpack packages.
      `node` and `npm` for packages installed from npm.
      `gcc` or `clang` to compile tree-sitter parsers.

  DESCRIPTION:

    Mason is a portable package manager for Neovim that runs everywhere Neovim
    runs. Its main job is putting tools on disk and making those tools visible to
    Neovim.

    It installs LSP servers, formatters and linters into
    `~/.local/share/nvim/mason/bin/` and adds that directory to Neovim's PATH —
    as any other process, Neovim inherits the environment variables from its
    parent process (the shell that launched it).

    To install tools manually use `:Mason` — in `lsp.lua` and `formatting.lua`
    we use other Mason plugins that install tools automatically.

  COMMANDS:
    To check if a tool is available to Neovim:
      `:echo executable("<lsp-command>")`
      E.g. `:echo executable("lua-language-server")`

--]]

return {
  {
    "mason-org/mason.nvim",
    lazy = false, -- set up on startup so its bin directory is added to PATH
    opts = {},
  },
}
