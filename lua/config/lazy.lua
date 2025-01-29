local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)
vim.filetype.add({ extension = { templ = "templ" } })
require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- import any extras modules here
    { import = "lazyvim.plugins.extras.lang.typescript" },
    { import = "lazyvim.plugins.extras.lang.json" },
    -- { import = "lazyvim.plugins.extras.ui.mini-animate" },
    { import = "lazyvim.plugins.extras.lang.go" },
    { import = "lazyvim.plugins.extras.lang.rust" },
    { import = "lazyvim.plugins.extras.lang.python" },
    {
      "sakhnik/nvim-gdb",
    },
    -- import/override with your plugins
    { import = "plugins" },
    -- THEME OPTIONS
    {
      "EdenEast/nightfox.nvim",
    },
    {
      "rebelot/kanagawa.nvim",
      opts = {
        setup = {},
      },
    },
    { "rose-pine/neovim", name = "rose-pine" },
    { "catppuccin/nvim", name = "catppuccin" },
    {
      "sho-87/kanagawa-paper.nvim",
      lazy = false,
      priority = 1000,
      opts = {},
    },
    { "luisiacc/gruvbox-baby" },
    { "savq/melange-nvim" },
    { "aliqyan-21/darkvoid.nvim" },
    {
      "killitar/obscure.nvim",
      lazy = false,
      priority = 1000,
      opts = {},
    },
    {
      "0xstepit/flow.nvim",
      lazy = false,
      priority = 1000,
      tag = "vX.0.0",
      opts = {},
    },
    { "datsfilipe/vesper.nvim" },
    {
      "vague2k/vague.nvim",
      config = function()
        require("vague").setup({
          -- optional configuration here
        })
      end,
    },
    -- Configure LazyVim to load colorscheme
    {
      "LazyVim/LazyVim",
      opts = {
        colorscheme = "obscure",
      },
    },
    {
      "neovim/nvim-lspconfig",
      opts = {
        servers = {
          templ = {},
        },
      },
    },
    {
      "ziglang/zig.vim",
    },
    {
      -- Autocompletion
      "hrsh7th/nvim-cmp",
      dependencies = {
        "hrsh7th/cmp-nvim-lsp",
      },
    },
    -- TEMPL CONFIG
    {
      "nvim-treesitter/nvim-treesitter",
      opts = function(_, opts)
        vim.list_extend(opts.ensure_installed, {
          "templ",
        })
      end,
    },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = { enabled = true }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
local lspconfig = require("lspconfig")

lspconfig.templ.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

lspconfig.tailwindcss.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "templ", "astro", "javascript", "typescript", "react" },
  init_options = { userLanguages = { templ = "html" } },
})

lspconfig.html.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "html", "templ" },
})

lspconfig.htmx.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "html", "templ" },
})

lspconfig.zls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "zig", "zon" },
  enable_build_on_save = true,
})

local cmp = require("cmp")
cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
  }),
})

require("nvim-treesitter.configs").setup({
  ensure_installed = { "templ" },
  sync_install = false,
  auto_install = true,
  ignore_install = { "javascript" },
  highlight = {
    enable = true,
  },
})
