local o = vim.opt

vim.g.mapleader = ','

-- Display
o.termguicolors = true
o.number = false
o.relativenumber = false
o.cursorline = true
o.showmatch = true
o.signcolumn = "auto"
o.showmode = false
o.laststatus = 3
o.fillchars = "vert:│,stl: ,stlnc:-"
o.cmdheight = 0
o.title = true

-- Search
o.ignorecase = true
o.smartcase = true

-- Splits
o.splitright = true
o.splitbelow = true

-- Text
o.visualbell = true
o.linebreak = true
o.list = false
o.listchars = "eol:↲,tab:▸ ,trail:·"
o.inccommand = "split"

-- Indentation
o.tabstop = 4
o.softtabstop = 4
o.shiftwidth = 4
o.expandtab = true

-- Completion
o.complete = ".,w,t"
o.wildmode = "list:longest,list:full"
o.wildignore = "*.swp,*.bak,*.pyc,*.class,.svn,.git"

-- Files
o.swapfile = false
o.backup = false
o.undodir = vim.fn.stdpath("data") .. "/undodir"
o.undofile = true
