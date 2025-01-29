return {
  -- Base Zig support
  {
    "ziglang/zig.vim",
    ft = "zig",
    config = function()
      -- Disable automatic formatting since we'll use conform.nvim
      vim.g.zig_fmt_autosave = 0
    end,
  },

  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        zls = {
          -- ZLS (Zig Language Server) settings
          settings = {
            zig = {
              checkOnSave = true,
              -- Enable semantic tokens for better highlighting
              semanticTokens = true,
              -- Enable inlay hints for better code understanding
              inlayHints = {
                parameterHints = true,
                typeHints = true,
                enumMemberValues = true,
                parameterNames = true,
              },
            },
          },
        },
      },
    },
  },

  -- Ensure ZLS is installed via Mason
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      table.insert(opts.ensure_installed, "zls")
    end,
  },

  -- Add Zig to Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      table.insert(opts.ensure_installed, "zig")
    end,
  },

  -- Configure conform.nvim for Zig formatting
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        zig = { "zigfmt" },
      },
    },
  },

  -- Configure debugging support (requires nvim-dap)
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      {
        "williamboman/mason.nvim",
        opts = function(_, opts)
          opts.ensure_installed = opts.ensure_installed or {}
          table.insert(opts.ensure_installed, "codelldb") -- For Zig debugging
        end,
      },
    },
  },
}
