-- Default options - these options only affect indenting in insert mode.

vim.o.tabstop = 2 -- Columns multiple used to display a horizontal Tab character
vim.o.shiftwidth = 0 -- Columns multiple for one level of (auto)indentation (`0` == 'tabstop')
vim.o.softtabstop = -1 -- Columns multiple for Tab in insert mode (`-1` == `shiftwidth`)
vim.o.expandtab = true -- Whether to insert spaces instead of a Tab character (does not convert existing tabs)

return {
  --[[

  -- Guess Indent ---------------------------------------------------------------

  This plugin reads the first hundred lines of a file when opened to detect
  whether spaces or tabs are used for indentation and how many colums are used
  for each indentation level.

  It then sets buffer local options to match what it sees. These local options
  override the global options set above.

  The plugin respects editorconfig settings. `.editorconfig` is a
  project-level formatting convention file used by most editors and IDEs to
  keep coding styles consistent across a team.

  When you open a buffer, Neovim checks for an `.editorconfig` file, if it finds
  one it sets the local buffer options accordingly:

    .editorconfig               Neovim local buffer option
    --------------------   ->   --------------------------
    indent_style = space        expandtab = true
    indent_style = tab          expandtab = false
    indent_size = 4             shiftwidth = 4
    tab_width = 4               tabstop = 4
    end_of_line                 fileformat

  Commands:
    `:GuessIndent` - toggle automatic indentation settings

  Configuration options:
     https://github.com/NMAC427/guess-indent.nvim#configuration

  --]]
  {
    "nmac427/guess-indent.nvim",
    opts = {
      auto_cmd = true, -- automatically run when openning a buffer
      override_editorconfig = false, -- whether to override settings in `.editorconfig`
      filetype_exclude = {
        "netrw",
        "tutor",
      },
      buftype_exclude = {
        "help",
        "nofile",
        "terminal",
        "prompt",
      },
      on_tab_options = { -- config when tabs are detected
        expandtab = false,
      },
      on_space_options = { -- config when spaces are detected
        expandtab = true,
        tabstop = "detected",
        softtabstop = "detected",
        shiftwidth = "detected",
      },
    },
  },

  --[[

  -- Conform -------------------------------------------------------------------

  Configure formatting tools.

  All the things described above only adjust editor behavior while you type,
  when you run a formatter, it will use its own settings for indentation.

  The cool thing is that some formatters, like stylua, also support
  editorconfig files. When both files are present (e.g. `.editorconfig` and
  `.stylua`) the latter takes presedence.

  Formatters are installed and managed by Mason. For a list of formatters see:
    `:h conform-formatters`
    https://github.com/stevearc/conform.nvim?tab=readme-ov-file#formatters

  Commands:
    `:ConformInfo` - check if a formatter is attached to the current buffer
    `:checkhealth conform` - verify
    `:h conform.setup` - plugin configuration options
    `:h conform.format` - format configuration options

  --]]
  {
    "stevearc/conform.nvim",
    lazy = false,
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format()
        end,
        mode = { "n", "x" },
        desc = "Format (Conform)",
      },
    },
    opts = {
      -- These tools are installed by Mason (see `lua/plugins/mason.lua`), which
      -- adds its `bin/` directory to Neovim's PATH. Verify with `:checkhealth conform`
      -- For configuration options, see `:h conform.setup`
      formatters_by_ft = {
        css = { "biome" },
        javascript = { "biome" },
        json = { "biome" },
        jsonc = { "biome" },
        lua = { "stylua", lsp_format = "never" },
        markdown = { "biome" },
        nix = { "nixfmt" },
        sh = { "shfmt" },
        typescript = { "biome" },
      },
      default_format_opts = {
        async = true, -- do not block
        lsp_format = "fallback", -- only used when no other formatters are available
        stop_after_first = true, -- by default only apply one, not all in sequence
      },
      format_on_save = true,
      notify_on_error = true,
      notify_no_formatters = true,
    },
  },
}
