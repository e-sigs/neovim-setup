-- LSP Configuration
return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "saghen/blink.cmp", -- For LSP capabilities
      { "j-hui/fidget.nvim", opts = {} }, -- LSP progress indicator
      { "folke/neodev.nvim", opts = {} }, -- Neovim Lua API completion
    },
    config = function()
      -- Setup mason first
      require("mason").setup({
        ui = {
          border = "rounded",
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })

      -- LSP servers to install and configure
      -- Focused on backend/GitOps development
      local servers = {
        -- Backend languages
        gopls = {
          settings = {
            gopls = {
              analyses = {
                unusedparams = true,
              },
              staticcheck = true,
              gofumpt = true,
            },
          },
        },
        pyright = {},
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              checkOnSave = {
                command = "clippy",
              },
            },
          },
        },

        -- GitOps/DevOps
        terraformls = {},
        tflint = {},
        yamlls = {
          settings = {
            yaml = {
              schemas = {
                ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
                ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "docker-compose*.yml",
                ["https://json.schemastore.org/kustomization.json"] = "kustomization.yaml",
                ["https://json.schemastore.org/chart.json"] = "Chart.yaml",
                kubernetes = "/*.k8s.yaml",
              },
              validate = true,
              completion = true,
              hover = true,
            },
          },
        },
        dockerls = {},
        docker_compose_language_service = {},
        bashls = {},
        jsonls = {},
        helm_ls = {},

        -- Lua for Neovim config
        lua_ls = {
          settings = {
            Lua = {
              workspace = { checkThirdParty = false },
              telemetry = { enable = false },
            },
          },
        },
      }

      -- Setup mason-lspconfig
      require("mason-lspconfig").setup({
        ensure_installed = vim.tbl_keys(servers),
        automatic_installation = true,
      })

      -- LSP capabilities with blink.cmp
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      -- On attach function for keymaps
      local on_attach = function(_, bufnr)
        local nmap = function(keys, func, desc)
          vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
        end

        -- LSP keymaps (navigation handled by Snacks picker: gd, gr, gi, gy)
        nmap("gD", vim.lsp.buf.declaration, "Go to declaration")
        nmap("K", vim.lsp.buf.hover, "Hover documentation")
        nmap("<C-k>", vim.lsp.buf.signature_help, "Signature help")
        nmap("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
        nmap("<leader>ca", vim.lsp.buf.code_action, "Code action")
        nmap("<leader>cf", function()
          vim.lsp.buf.format({ async = true })
        end, "Format buffer")
      end

      -- Setup each server
      require("mason-lspconfig").setup_handlers({
        function(server_name)
          local server_opts = servers[server_name] or {}
          server_opts.capabilities = capabilities
          server_opts.on_attach = on_attach
          require("lspconfig")[server_name].setup(server_opts)
        end,
      })

      -- Diagnostic configuration
      vim.diagnostic.config({
        virtual_text = {
          prefix = "●",
          source = "if_many",
        },
        float = {
          border = "rounded",
          source = "always",
        },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })

      -- Diagnostic signs
      local signs = { Error = " ", Warn = " ", Hint = "󰌵 ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end
    end,
  },
}
