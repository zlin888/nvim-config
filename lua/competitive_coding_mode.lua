local M = {}

function M.enable()
  -- Stop all LSP clients
  vim.cmd("LspStop")
  
  -- Disable nvim-cmp for all buffers
  local status_ok, cmp = pcall(require, "cmp")
  if status_ok then
    cmp.setup({ enabled = false })
  end
  
  -- Optional: Add a status line indicator or message
  print("Competitive Coding Mode: LSP and autocompletion disabled")
end

-- Create a Vim command
vim.api.nvim_create_user_command(
  'CompetitiveCodingMode', -- Name of the command
  function()                -- Function to execute
    M.enable()
  end,
  { nargs = 0 }            -- Command options (no arguments expected)
)

-- Auto-enable competitive coding mode for specific paths
local function auto_enable_vim_enter()
  local cwd = vim.fn.getcwd() -- Get the current working directory
  if cwd:match("code/cf") then
    M.enable()
  end
end

-- Set up autocommand to check the path when Neovim starts
vim.api.nvim_create_autocmd("VimEnter", {
  callback = auto_enable_vim_enter,
})

return M