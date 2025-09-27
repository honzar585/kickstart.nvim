-- Create this file: ~/.config/nvim/lua/telescope/_extensions/clipmenu.lua

local telescope = require 'telescope'
local finders = require 'telescope.finders'
local pickers = require 'telescope.pickers'
local conf = require('telescope.config').values
local actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'

local function get_clipmenu_entries()
  local cache_dir = os.getenv 'XDG_CACHE_HOME' or (os.getenv 'HOME' .. '/.cache')
  local clipmenu_dir = cache_dir .. '/clipmenu/clipmenu.7.1000'
  local entries = {}

  -- Get clipmenu cache files, sorted by modification time (newest first)
  local cmd = string.format("find '%s' -type f -name '*.clip' -printf '%%T@ %%p\\n' 2>/dev/null | sort -nr | head -50 | cut -d' ' -f2-", clipmenu_dir)
  local handle = io.popen(cmd)

  if handle then
    for filepath in handle:lines() do
      local file = io.open(filepath, 'r')
      if file then
        local content = file:read '*all'
        file:close()

        if content and content ~= '' then
          -- Clean up content for display
          local display = content:gsub('[\n\r]', ' '):gsub('%s+', ' '):sub(1, 100)
          if #content > 100 then
            display = display .. '...'
          end

          -- Get file modification time for sorting
          local stat = vim.loop.fs_stat(filepath)
          local mtime = stat and stat.mtime.sec or 0

          table.insert(entries, {
            display = display,
            content = content:gsub('[\n\r]*$', ''), -- Remove trailing newlines
            path = filepath,
            mtime = mtime,
          })
        end
      end
    end
    handle:close()
  end

  -- Fallback method if find with printf doesn't work
  if #entries == 0 then
    local simple_cmd = string.format("ls -1t '%s' 2>/dev/null | head -20", clipmenu_dir)
    local simple_handle = io.popen(simple_cmd)

    if simple_handle then
      for filename in simple_handle:lines() do
        local filepath = clipmenu_dir .. '/' .. filename
        local file = io.open(filepath, 'r')
        if file then
          local content = file:read '*all'
          file:close()

          if content and content ~= '' then
            local display = content:gsub('[\n\r]', ' '):gsub('%s+', ' '):sub(1, 100)
            if #content > 100 then
              display = display .. '...'
            end

            table.insert(entries, {
              display = display,
              content = content:gsub('[\n\r]*$', ''),
              path = filepath,
              mtime = 0,
            })
          end
        end
      end
      simple_handle:close()
    end
  end

  return entries
end

local function clipmenu_picker(opts)
  opts = opts or {}

  local entries = get_clipmenu_entries()

  if #entries == 0 then
    vim.notify('No clipmenu entries found. Make sure clipmenud is running.', vim.log.levels.WARN)
    return
  end

  pickers
    .new(opts, {
      prompt_title = 'Clipmenu History',
      finder = finders.new_table {
        results = entries,
        entry_maker = function(entry)
          return {
            value = entry,
            display = entry.display,
            ordinal = entry.content,
          }
        end,
      },
      sorter = conf.generic_sorter(opts),
      previewer = conf.grep_previewer(opts),
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          local selection = action_state.get_selected_entry()
          actions.close(prompt_bufnr)

          if selection then
            -- Copy to system clipboard
            vim.fn.setreg('+', selection.value.content)
            vim.fn.setreg('"', selection.value.content)

            -- Paste based on current mode
            local mode = vim.api.nvim_get_mode().mode
            vim.schedule(function()
              if mode == 'i' then
                -- Insert mode: put text at cursor
                local pos = vim.api.nvim_win_get_cursor(0)
                vim.api.nvim_put({ selection.value.content }, 'c', false, true)
              else
                -- Normal mode: use paste command
                vim.cmd 'normal! "+p'
              end
              vim.notify 'Pasted from clipmenu'
            end)
          end
        end)

        -- Copy without pasting (Ctrl+y)
        map('i', '<C-y>', function()
          local selection = action_state.get_selected_entry()
          actions.close(prompt_bufnr)

          if selection then
            vim.fn.setreg('+', selection.value.content)
            vim.fn.setreg('"', selection.value.content)
            vim.notify 'Copied to clipboard'
          end
        end)

        -- Preview full content (Ctrl+p)
        map('i', '<C-p>', function()
          local selection = action_state.get_selected_entry()
          if selection then
            local content_lines = vim.split(selection.value.content, '\n')
            local buf = vim.api.nvim_create_buf(false, true)
            vim.api.nvim_buf_set_lines(buf, 0, -1, false, content_lines)
            vim.api.nvim_buf_set_option(buf, 'filetype', 'text')

            local width = math.min(100, vim.o.columns - 4)
            local height = math.min(20, #content_lines + 2)

            vim.api.nvim_open_win(buf, true, {
              relative = 'cursor',
              width = width,
              height = height,
              row = 1,
              col = 0,
              style = 'minimal',
              border = 'rounded',
              title = ' Full Content ',
              title_pos = 'center',
            })

            -- Keymaps to close preview
            local close_preview = function()
              if vim.api.nvim_buf_is_valid(buf) then
                vim.api.nvim_buf_delete(buf, { force = true })
              end
            end

            vim.keymap.set('n', 'q', close_preview, { buffer = buf, nowait = true })
            vim.keymap.set('n', '<Esc>', close_preview, { buffer = buf, nowait = true })
          end
        end)

        return true
      end,
    })
    :find()
end

return telescope.register_extension {
  exports = {
    clipmenu = clipmenu_picker,
  },
}
