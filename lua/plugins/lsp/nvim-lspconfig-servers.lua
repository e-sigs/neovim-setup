-- lsp-servers - Language Server Protocol configuration (Neovim 0.11+)
return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- Default capabilities (extended by completion plugin if available)
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok, blink = pcall(require, "blink.cmp")
      if ok then
        capabilities = blink.get_lsp_capabilities(capabilities)
      end

      -- LSP keymaps (set on LspAttach)
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
        callback = function(ev)
          local bufnr = ev.buf
          local client = vim.lsp.get_client_by_id(ev.data.client_id)

          local keymap = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
          end

          keymap("n", "K", vim.lsp.buf.hover, "Hover documentation")
          keymap("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
          keymap("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
          keymap("v", "<leader>ca", vim.lsp.buf.code_action, "Code action")
          keymap("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
          keymap("n", "<leader>cf", function() vim.lsp.buf.format({ async = true }) end, "Format buffer")
          keymap("v", "<leader>cf", function() vim.lsp.buf.format({ async = true }) end, "Format selection")
          keymap("n", "<leader>cl", "<cmd>checkhealth lsp<cr>", "LSP info")
          keymap("i", "<C-k>", vim.lsp.buf.signature_help, "Signature help")

          -- Enable inlay hints if supported
          if client and client:supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
          end
        end,
      })

      -- Server configurations using vim.lsp.config (Neovim 0.11+)
      vim.lsp.config("*", {
        capabilities = capabilities,
      })

      vim.lsp.config("gopls", {
        settings = {
          gopls = {
            gofumpt = true,
            staticcheck = true,
            analyses = {
              unusedparams = true,
              shadow = true,
            },
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
          },
        },
      })

      vim.lsp.config("pyright", {
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
            },
          },
        },
      })

      vim.lsp.config("rust_analyzer", {
        settings = {
          ["rust-analyzer"] = {
            checkOnSave = {
              command = "clippy",
            },
            cargo = {
              allFeatures = true,
            },
          },
        },
      })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            workspace = {
              checkThirdParty = false,
              library = { vim.env.VIMRUNTIME },
            },
            completion = { callSnippet = "Replace" },
            diagnostics = {
              globals = { "vim", "Snacks" },
            },
            hint = { enable = true },
          },
        },
      })

      vim.lsp.config("yamlls", {
        settings = {
          yaml = {
            schemas = {
              ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
              ["https://json.schemastore.org/kustomization.json"] = "kustomization.yaml",
              ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "docker-compose*.yml",
            },
            validate = true,
            completion = true,
          },
        },
      })

      vim.lsp.config("helm_ls", {
        settings = {
          ["helm-ls"] = {
            yamlls = { path = "yaml-language-server" },
          },
        },
      })

      vim.lsp.config("jsonls", {
        settings = {
          json = {
            validate = { enable = true },
          },
        },
      })

      -- Enable servers (must be installed separately and available on PATH)
      vim.lsp.enable({
        "gopls",
        "pyright",
        "rust_analyzer",
        "terraformls",
        "tflint",
        "yamlls",
        "dockerls",
        "docker_compose_language_service",
        "bashls",
        "helm_ls",
        "lua_ls",
        "jsonls",
      })

      -- Diagnostic configuration
      vim.diagnostic.config({
        virtual_text = {
          prefix = "●",
          spacing = 4,
        },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "●",
            [vim.diagnostic.severity.WARN] = "●",
            [vim.diagnostic.severity.HINT] = "●",
            [vim.diagnostic.severity.INFO] = "●",
          },
        },
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = "rounded",
          source = true,
        },
      })
    end,
  },
}
