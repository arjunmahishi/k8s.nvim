local kubectl = require("k8s.kubectl")
local log = require('k8s.log').print
local output = require('k8s.output')
local utils = require('k8s.utils')

local pickers = require("telescope.pickers")
local finders = require ("telescope.finders")
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

local default_config_type = 'json'

local function is_valid()
  if utils.get_kube_config() == nil then
    log('KUBECONFIG could not be found') -- TODO: add steps to fix this
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
      utils.get_kube_config(), namespace
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
            utils.get_kube_config(), namespace, selection[1]
          )
          output.write_to_buffer(config, default_config_type)
        end)
        return true
      end,
    }):find()
  end
end

local function pods(namespace)
  return function(opts)
    if not is_valid() then
      return
    end

    log("loading pods...")
    local pods_list = kubectl.get_pods(
      utils.get_kube_config(), namespace
    )
    if pods_list == nil then
      return true
    end
    log("loaded config-maps")

    opts = opts or require("telescope.themes").get_dropdown{}
    pickers.new(opts, {
      prompt_title = string.format("Pods in '%s'", namespace),
      finder = finders.new_table {
        results = pods_list
      },
      sorter = conf.generic_sorter(opts),
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          local pod_details = kubectl.describe_pod(
            utils.get_kube_config(), namespace, selection[1]
          )

          output.write_to_buffer(pod_details)
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
    local namespace_list = kubectl.get_namespaces(utils.get_kube_config())
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

          pods(selection[1])()
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

local function pick_config(kube_config_dir)
  return function(opts)
    if kube_config_dir == nil then
      log("kube_config_dir is not setup")
      return
    end

    local config_paths = utils.list_files(kube_config_dir)

    opts = opts or require("telescope.themes").get_dropdown{}
    pickers.new(opts, {
      prompt_title = "Kube config",
      finder = finders.new_table {
        results = config_paths
      },
      sorter = conf.generic_sorter(opts),
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()

          utils.set_kube_config(selection[1])
          log(string.format("KUBECONFIG has been set to %s", selection[1]))
        end)
        return true
      end,
    }):find()
  end
end

return {
  namespaces = namespaces(),
  config_maps = config_maps,
  pods = pods,
  pick_config = pick_config,
}
