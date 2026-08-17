lua << EOF
local ok, nvim_tree = pcall(require, "nvim-tree")
if not ok then
  return
end

nvim_tree.setup({
  sync_root_with_cwd = true,
  reload_on_bufenter = true,
  update_focused_file = {
    enable = true,
  },
  renderer = {
    highlight_opened_files = "name",
    icons = {
      web_devicons = {
        file = { enable = false },
        folder = { enable = false },
      },
      show = {
        file = false,
        folder = false,
        folder_arrow = true,
        git = true,
      },
      glyphs = {
        folder = {
          arrow_closed = "▸",
          arrow_open = "▾",
        },
        git = {
          unstaged = "✗",
          staged = "✓",
          unmerged = "!",
          renamed = "➜",
          untracked = "★",
          deleted = "✗",
          ignored = "◌",
        },
      },
    },
  },
  modified = {
    enable = true,
  },
  actions = {
    open_file = {
      window_picker = {
        enable = false,
      },
    },
  },
})

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function(data)
    local ft = vim.bo[data.buf].filetype
    if ft == "gitcommit" or ft == "gitrebase" then
      return
    end

    vim.schedule(function()
      require("nvim-tree.api").tree.open({ find_file = true })
      vim.cmd("noautocmd wincmd p")
    end)
  end,
})
EOF

nnoremap <silent> <leader>e :NvimTreeFindFileToggle<CR>
