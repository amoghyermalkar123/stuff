-- File: lua/plugins/zig.lua
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
          settings = {
            zig = {
              checkOnSave = true,
              semanticTokens = true,
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

  -- Mason setup for LSP
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "zls", -- Zig Language Server
        "codelldb", -- Debugger (still needed for dap.lua)
      })
    end,
  },

  -- Treesitter configuration
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

  -- Add additional useful Zig-specific keymaps
  {
    "LazyVim/LazyVim",
    opts = {
      -- Add any custom keymaps here
      keys = {
        -- Example keymap for running tests
        { "<leader>zt", "<cmd>!zig test %<cr>", desc = "Zig Test Current File" },
        -- Example keymap for building
        { "<leader>zb", "<cmd>!zig build<cr>", desc = "Zig Build" },
      },
    },
  },
}
