-- lsp-config - Language Server Protocol
return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    opts = {
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "gopls", "pyright", "rust_analyzer",
        "terraformls", "tflint", "yamlls",
        "dockerls", "docker_compose_language_service",
        "bashls", "jsonls", "helm_ls", "lua_ls",
      },
      automatic_installation = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "saghen/blink.cmp",
      { "j-hui/fidget.nvim", opts = {} },
      { "folke/lazydev.nvim", ft = "lua", opts = {} },
    },
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      -- LSP keymaps on attach
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local bufnr = args.buf
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
        end,
      })

      -- Server configurations using vim.lsp.config (Neovim 0.11+)
      vim.lsp.config("gopls", {
        capabilities = capabilities,
        settings = {
          gopls = {
            analyses = { unusedparams = true },
            staticcheck = true,
            gofumpt = true,
          },
        },
      })

      vim.lsp.config("pyright", {
        capabilities = capabilities,
      })

      vim.lsp.config("rust_analyzer", {
        capabilities = capabilities,
        settings = {
          ["rust-analyzer"] = {
            checkOnSave = { command = "clippy" },
          },
        },
      })

      vim.lsp.config("terraformls", { capabilities = capabilities })
      vim.lsp.config("tflint", { capabilities = capabilities })

      vim.lsp.config("yamlls", {
        capabilities = capabilities,
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
      })

      vim.lsp.config("dockerls", { capabilities = capabilities })
      vim.lsp.config("docker_compose_language_service", { capabilities = capabilities })
      vim.lsp.config("bashls", { capabilities = capabilities })
      vim.lsp.config("jsonls", { capabilities = capabilities })
      vim.lsp.config("helm_ls", { capabilities = capabilities })

      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
      })

      -- Enable all configured servers
      vim.lsp.enable({
        "gopls", "pyright", "rust_analyzer",
        "terraformls", "tflint", "yamlls",
        "dockerls", "docker_compose_language_service",
        "bashls", "jsonls", "helm_ls", "lua_ls",
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
