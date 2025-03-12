-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*",
  callback = function()
    if vim.fn.filereadable(".nvim/deployment.lua") == 1 then
      require("transfer.transfer").upload_file()
    end
  end,
})
