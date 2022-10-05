local kubectl = require("k8s.kubectl")
local log = require('k8s.log').print
local output = require('k8s.output')

local pickers = require("telescope.pickers")
local finders = require ("telescope.finders")
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

local default_config_type = 'json'

local function is_valid()
  if os.getenv('KUBECONFIG') == nil then
    log('KUBECONFIG has to be set in the environment')
    return false
  end

  return true
end

local function config_maps(namespace)
  return function(opts)
    if not is_valid() then
      return
    end

    log("loading config-maps...")
    local config_maps_list = kubectl.get_config_maps(
      os.getenv('KUBECONFIG'), namespace
    )
    if config_maps_list == nil then
      return true
    end
    log("loaded config-maps")

    opts = opts or require("telescope.themes").get_dropdown{}
    pickers.new(opts, {
      prompt_title = string.format("Config maps in '%s'", namespace),
      finder = finders.new_table {
        results = config_maps_list
      },
      sorter = conf.generic_sorter(opts),
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()

          local config = kubectl.describe_config_map(
            os.getenv('KUBECONFIG'), namespace, selection[1]
          )
          output.write_to_buffer(config, default_config_type)
        end)
        return true
      end,
    }):find()
  end
end

local function namespaces()
  return function(opts)
    if not is_valid() then
      return
    end

    log("loading namespaces...")
    local namespace_list = kubectl.get_namespaces(os.getenv('KUBECONFIG'))
    if namespace_list == nil then
      return true
    end
    log("loaded namespaces")

    opts = opts or require("telescope.themes").get_dropdown{}
    pickers.new(opts, {
      prompt_title = "Namespaces",
      finder = finders.new_table {
        results = namespace_list
      },
      sorter = conf.generic_sorter(opts),
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()

          config_maps(selection[1])()
        end)

        map("i", "<c-c>", function ()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          config_maps(selection[1])()
        end)

        return true
      end,
    }):find()
  end
end

return {
  namespaces = namespaces(),
  config_maps = config_maps,
}
