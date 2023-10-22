vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = true 
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

vim.g.mapleader = " "

vim.g.autoread = true

-- Colorscheme
vim.cmd.colorscheme("onedark")

-- Autosave
vim.cmd('autocmd FocusLost, BufLeave, BufHidden * silent! wall')

-- Copilot parse yaml
vim.cmd('filetype on')  -- Enable filetype detection
vim.cmd('autocmd BufRead,BufNewFile *.yml,*.yaml set filetype=yaml')  -- Set the filetype for YAML files
vim.g.copilot_filetypes = {yaml = true, yml = true, markdown = true}
