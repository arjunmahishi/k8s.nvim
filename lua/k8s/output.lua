-- this file controls how the output is displayed. Currently, there are two

local str_split = require('k8s.utils').str_split
local log = require('k8s.log').print

local last_output = nil
local default_filetype = 'text'

local function write_to_buffer(output, filetype)
  local output_win = vim.api.nvim_get_current_win()
  local output_buf = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_win_set_buf(output_win, output_buf)

  -- switch to the output window and write the output to the buffer
  vim.api.nvim_set_current_win(output_win)
  vim.api.nvim_buf_set_lines(output_buf, 0, -1, false, str_split(output, '\n'))

  vim.bo.filetype = filetype or default_filetype
  vim.bo.modifiable = false

  last_output = output
end

local function show_last_output()
  if last_output == nil then
    log("you haven't run anything yet")
    return
  end

  write_to_buffer(last_output)
end

return {
  write_to_buffer = write_to_buffer,
  show_last_output = show_last_output,
}
