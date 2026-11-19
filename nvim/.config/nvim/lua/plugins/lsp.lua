--[[

  REQUIREMENTS:

    The LSP servers configured here are installed in `mason.lua`. Keep in mind
    that Mason uses the tool name to install packages and neovim LSP uses
    neovim names to configure them.

    IMPORTANT:
      Some of the LSP servers are not available in Mason, install those
      manually using the system package manager.

  EXPLANATION:

    neovim/nvim-lspconfig:
      Has the default configurations for all LSPs. `vim.lsp.config`
      automatically finds them and merges them with any configurations you
      setup here.

    saghen/blink.cmp:
      Completion plugin that works with the LSP.

    b0o/schemastore.nvim:
      Provides the SchemaStore catalog for use with jsonls and yamlls — these
      schemas give static files the same features as LSPs.

  COMMANDS:

    `:h lspconfig-all` — default configuration options of each LSP.

    `:h lsp` — everything you need to know about Neovim LSP.

    `:checkhealth vim.lsp` — verify if there are any problems with LSP config.

    `:h vim.lsp.Config` — attributes accepted to configure an LSP.

    `:=vim.lsp.protocol.make_client_capabilities()` - Neovim capabilities
    `:=vim.lsp.get_clients()[1].server_capabilities` - attached LSP capabilities

  VIDEOS:

    Understanding Neovim #7 - Language Server Protocol
      https://www.youtube.com/watch?v=HL7b63Hrc8U&list=PLx2ksyallYzW4WNYHD9xOFrPRYGlntAft&index=7

    Common pitfalls
      https://youtu.be/UVcC5ifbXL8?si=LJ8-DBjCPvQ3DZmr&t=439

--]]

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "saghen/blink.cmp",
      "b0o/schemastore.nvim",
    },
    config = function()
      --------------------------------------------------------------------------

      -- Configure LSP servers:
      --   These configurations will be merged with the ones provided by
      --   `nvim-lspconfig`. Pass an emtpy table `{}` to use the default config.
      --   See `:h lspconfig-all`.

      local servers = {
        -- mise --
        --   The LSP comes builtin, no need to install with Mason
        mise = {},

        -- nixd --
        --   The LSP is not available in Mason, install with package manager
        nixd = {
          -- watch https://www.youtube.com/watch?v=M_zMoHlbZBY
          cmd = { "nixd" },
          settings = {
            nixd = {
              nixpkgs = {
                expr = "import <nixpkgs> { }",
              },
              options = {
                nixos = {
                  expr = '(buintins.getFlake "/home/mabq/.local/share/mynix").nixosConfigurations.xps.options',
                },
              },
            },
          },
        },

        -- bash-language-server --
        bashls = {},

        -- json-lsp --
        jsonls = {
          settings = {
            json = {
              -- Inject all schemas from SchemaStore
              schemas = require("schemastore").json.schemas(),
              -- Enable validation (strongly recommended)
              validate = { enable = true },
            },
          },
        },

        -- yaml-language-server --
        yamlls = {},

        -- lua-language-server --
        lua_ls = {
          on_init = function(client)
            if client.workspace_folders then
              local path = client.workspace_folders[1].name
              if
                path ~= vim.fn.stdpath "config"
                and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
              then
                return
              end
            end
            client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
              runtime = {
                -- Tell the language server which version of Lua you're using (most
                -- likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
                -- Tell the language server how to find Lua modules same way as Neovim
                -- (see `:h lua-module-load`)
                path = {
                  "lua/?.lua",
                  "lua/?/init.lua",
                },
              },
              -- Make the server aware of Neovim runtime files
              workspace = {
                checkThirdParty = false,
                library = {
                  vim.env.VIMRUNTIME,
                  -- For LSP Settings Type Annotations: https://github.com/neovim/nvim-lspconfig#lsp-settings-type-annotations
                  vim.api.nvim_get_runtime_file("lua/lspconfig", false)[1],
                },
                -- Or pull in all of 'runtimepath'.
                -- NOTE: this is a lot slower and will cause issues when working on
                -- your own configuration.
                -- See https://github.com/neovim/nvim-lspconfig/issues/3189
                -- library = vim.api.nvim_get_runtime_file('', true),
              },
            })
          end,
          settings = {
            Lua = {},
          },
        },
      }

      --------------------------------------------------------------------------

      -- Configure and start each server --

      for name, config in pairs(servers) do
        -- Add LSP capabilities provided by Blink
        config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
        vim.lsp.config(name, config)
        -- if vim.fn.executable() == 1 then
        vim.lsp.enable(name)
        -- end
      end

      --------------------------------------------------------------------------

      -- Add keymaps to the buffer when an LSP is attached --

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }), -- clear to avoid duplication
        callback = function(event)
          local bufnr = event.buf
          local client = assert(vim.lsp.get_client_by_id(event.data.client_id), "Must have valid client (LSP)")
          local telescope = require "telescope.builtin"

          vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"

          -- Customize default lsp keymaps (see `:h lsp-defaults`) -------------
          --   K is not listed in the documentation but it works

          --   Use telescope to show found references
          vim.keymap.set("n", "grr", telescope.lsp_references, { buffer = bufnr, desc = "Go to References (LSP)" })

          -- Go to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Go to Definition (LSP)" })

          -- Go to Declaration.
          --  For example, in C this would take you to the header.
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr, desc = "Go to Declaration (LSP)" })

          --   Use telescope to show symbols of the current document
          vim.keymap.set(
            "n",
            "gO",
            telescope.lsp_document_symbols,
            { buffer = bufnr, desc = "Open Document Symbols (LSP)" }
          )

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          vim.keymap.set(
            "n",
            "gW",
            telescope.lsp_dynamic_workspace_symbols,
            { buffer = bufnr, desc = "Open Workspace Symbols (LSP)" }
          )

          -- Create a keymap to toggle inlay hints (if the language server supports them)
          --  This may be unwanted, since they displace some of your code
          if client and client:supports_method("textDocument/inlayHint", bufnr) then
            vim.keymap.set("n", "<leader>ti", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = bufnr })
            end, { buffer = bufnr, desc = "Inlay Hints (LSP)" })
          end
        end,
      })
    end,
  },

  -- { "j-hui/fidget.nvim", opts = {} },

  -- {
  --   "dmmulroy/tsc.nvim",
  --   config = function()
  --     require("tsc").setup {
  --       run_as_monorepo = true,
  --     }
  --   end,
  -- },

  -- {
  --   "pmizio/typescript-tools.nvim",
  --   dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  -- },
}
