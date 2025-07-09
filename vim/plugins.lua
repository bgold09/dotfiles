if type(vim.g.vscode) == "nil" then
    require("telescope").load_extension "frecency"
    require("telescope").setup {
      defaults = {
          preview = false,
      },
      pickers = {
        find_files = {
          find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
        },
      },
    }

    require('neo-tree').setup {
      filesystem = {
        window = {
          ["/"] = "fuzzy_finder",
        },
      },
    }

    local custom_solarized = require('lualine.themes.solarized_dark')
    custom_solarized.insert.a.bg = '#b58900'
    require('lualine').setup {
      options = { theme  = custom_solarized },
      sections = {
        lualine_b = {'branch', 'diagnostics'},
      },
      tabline = {
        lualine_a = {'buffers'},
      },
    }

    require("gitsigns").setup {
      signs = {
        add          = { text = '+' },
        change       = { text = '~' },
        delete       = { text = '-' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
      },
    }

    require("scrollbar").setup({
      marks = {
        Cursor = {
          text = "●",
          priority = 0,
          color = nil,
          cterm = nil,
          highlight = "ScrollbarCursorHandle",
        },
      },
    })
    require("scrollbar.handlers.gitsigns").setup()
end
