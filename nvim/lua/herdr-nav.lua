-- vim-herdr-navigation — Neovim side (vendored, Alt-chord fork)
--
-- Upstream: https://github.com/paulbkim-dev/vim-herdr-navigation
-- Local patch: navigation is bound to <A-h/j/k/l> instead of upstream <C-h/j/k/l>,
-- so it does not clash with our JetBrains-style <C-h>/<C-l> jump aliases
-- (see keymaps.lua) or shadow readline Ctrl+L/Ctrl+K in shell panes.
--
-- Seamless <A-h/j/k/l> navigation between Neovim splits and herdr panes: move
-- between Neovim splits, and at a split edge hand off to herdr so focus crosses
-- into the neighbouring herdr pane. When not inside herdr it falls back to tmux
-- (if any) or plain wincmd, so a tmux setup keeps working.
-- Required from init.lua after keymaps so it wins over other <A-h/j/k/l> maps.

local function nav(wincmd, dir)
  local prev = vim.api.nvim_get_current_win()
  vim.cmd("wincmd " .. wincmd)
  if vim.api.nvim_get_current_win() ~= prev then
    return -- moved within Neovim
  end
  -- At a split edge: cross into the surrounding multiplexer.
  if vim.env.HERDR_PANE_ID and vim.env.HERDR_PANE_ID ~= "" then
    local herdr = vim.env.HERDR_BIN_PATH
    if herdr == nil or herdr == "" then
      herdr = "herdr"
    end
    vim.fn.system({ herdr, "pane", "focus", "--direction", dir, "--current" })
  elseif vim.env.TMUX and vim.env.TMUX ~= "" then
    local tmux = { left = "Left", down = "Down", up = "Up", right = "Right" }
    pcall(vim.cmd, "TmuxNavigate" .. tmux[dir])
  end
end

local function map(lhs, wincmd, dir, desc)
  vim.keymap.set("n", lhs, function()
    nav(wincmd, dir)
  end, { silent = true, noremap = true, desc = desc })
end

map("<A-h>", "h", "left", "Navigate left (vim/herdr)")
map("<A-j>", "j", "down", "Navigate down (vim/herdr)")
map("<A-k>", "k", "up", "Navigate up (vim/herdr)")
map("<A-l>", "l", "right", "Navigate right (vim/herdr)")
