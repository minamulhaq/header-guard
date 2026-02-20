-- Prevent loading twice
if vim.g.loaded_header_guard then
  return
end
vim.g.loaded_header_guard = 1

-- Create user command (runs at startup)
vim.api.nvim_create_user_command("Hg", function()
  require('header-guard').insert_guard()  -- Lazy-loads lua/header-guard/init.lua
end, {})

-- Auto-insert guard when creating new .h files
vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = "*.h",
  callback = function()
    require('header-guard').insert_guard()
  end,
})

-- Global keymap
vim.keymap.set("n", "<leader>hg", function()
  require('header-guard').insert_guard()
end, { desc = "Insert header guard" })
