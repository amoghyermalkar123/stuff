-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
vim.api.nvim_create_autocmd("VimLeavePre", {
  group = vim.api.nvim_create_augroup("lazyvim_quit_on_sigterm", { clear = true }),
  callback = function()
    -- Save all modified buffers
    vim.cmd("silent! wa")
    -- Delete swap files for all buffers
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      local swap_file = vim.fn.swapname(buf)
      if swap_file and vim.fn.filereadable(swap_file) == 1 then
        vim.fn.delete(swap_file)
      end
    end
    -- Optional: Close all buffers
    vim.cmd("silent! bufdo bd")
  end,
})
