-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlight on search
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>E', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
vim.keymap.set('n', '<C-f>', '<C-w>|', { desc = 'Put current panel in full width' })

-- [[ Basic Autocommands ]]

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- MY REMAPS

vim.keymap.set('n', '<leader>e', vim.cmd.NvimTreeToggle)

vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

vim.keymap.set('n', 'J', 'mzJ`z')

vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

vim.keymap.set('n', '<leader>ta', function()
  RunAndRegisterTest ':te go test ./...'
end)

vim.keymap.set('n', '<leader>t!', function()
  RunAndRegisterTest(vim.fn.getreg 't')
end)

vim.keymap.set('n', '<leader>tp', function()
  RunAndRegisterTest(':te go test ./' .. vim.fn.expand '%:h')
end)

vim.keymap.set('n', '<leader>tvp', function()
  RunAndRegisterTest(':te go test -v ./' .. vim.fn.expand '%:h')
end)

vim.keymap.set('n', '<leader>tt', function()
  RunAndRegisterTest(':te go test ./' .. vim.fn.expand '%:h' .. '/ -run ^' .. vim.fn.expand '<cword>' .. '$')
end)

vim.keymap.set('n', '<leader>tvt', function()
  RunAndRegisterTest(':te go test ./' .. vim.fn.expand '%:h' .. '/ -v -run ^' .. vim.fn.expand '<cword>' .. '$')
end)

vim.keymap.set('n', '<leader>jf', function()
  local unformattedJson = vim.trim(vim.fn.getreg '"')
  vim.fn.setreg('j', vim.fn.system('echo ' .. unformattedJson .. ' | jq'))
  vim.cmd 'new temp.json | put=@j'
end)

vim.keymap.set('n', '<leader>T', '<C-w>v :te <CR>')

vim.keymap.set({ 'n', 'v' }, '<leader>ud', "\"=system(['node', '../../helpers/uuidV6/index.js'])<CR>p")

vim.keymap.set('n', '<leader>%', '<S-v>$%')
vim.keymap.set('v', '<leader>%', '$%')
vim.keymap.set('n', '<leader>}', '<S-v>}')
vim.keymap.set('n', '<leader>{', '<S-v>{')

function RunAndRegisterTest(command)
  FindAndCloseTerminalBuffer()
  vim.cmd("let @t = '" .. command .. "'")
  vim.cmd ':vne'
  vim.cmd(command)
end

function FormatJson(command)
  FindAndCloseTerminalBuffer()
  vim.cmd("let @t = '" .. command .. "'")
  vim.cmd ':vne'
  vim.cmd(command)
end

function FindAndCloseTerminalBuffer()
  local terminalBuf = vim.fn.execute ':buffers aF'
  if terminalBuf == '' then
    return
  end

  local buffNums = terminalBuf:match '^%s*(%d+)'
  if buffNums ~= -1 then
    vim.cmd(':' .. buffNums .. 'bd')
  end
end

-- Git Fugitive remaps
vim.keymap.set('n', '<leader>gs', vim.cmd.Git)

-- Smoothie remaps
vim.keymap.set({ 'n', 'v', 'x' }, '<C-d>', '<cmd>call smoothie#do("<C-D>") <CR>')
vim.keymap.set({ 'n', 'v', 'x' }, '<C-u>', '<cmd>call smoothie#do("<C-U>") <CR>')
