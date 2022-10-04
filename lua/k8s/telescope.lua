local kubectl = require("k8s.kubectl")
local pickers = require("telescope.pickers")
local finders = require ("telescope.finders")
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

local function namespaces()
  return function(opts)
    local namespaceList = kubectl.getNamespaces(os.getenv('KUBECONFIG'))
    opts = opts or require("telescope.themes").get_dropdown{}

    pickers.new(opts, {
      prompt_title = "Namespaces",
      finder = finders.new_table {
        results = namespaceList
      },
      sorter = conf.generic_sorter(opts),
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()

          -- if an existing command is selected, it should be executed. Else, a
          -- new command sould be created with that name
          -- if selection ~= nil then
          --   run_custom_cmd(selection[1])
          --   return
          -- end

          -- cmd.set_custom_cmd(action_state.get_current_line())
          print(selection[1])
        end)

        -- map("i", "<c-e>", function ()
        --   actions.close(prompt_bufnr)
        --   local selection = action_state.get_selected_entry()
        --   cmd.set_custom_cmd(selection[1])
        -- end)
        return true
      end,
    }):find()
  end
end

return {
  namespaces = namespaces()
}
