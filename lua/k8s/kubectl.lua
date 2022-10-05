local log = require('k8s.log').print

local get_namespaces_cmd = 'kubectl get namespaces -o name --kubeconfig %s'
local get_config_maps_cmd = 'kubectl get configmaps --namespace %s -o name --kubeconfig %s'
local describe_config_map_cmd = 'kubectl get configmaps %s --namespace %s -o jsonpath="{.data.config}" --kubeconfig %s'

local function get_namespaces(kubeconfig)
  local out = vim.fn.system(string.format(get_namespaces_cmd, kubeconfig))

  local namespaces = {}
  for s in out:gmatch('namespace/(%g+)') do
    table.insert(namespaces, s)
  end

  if #namespaces ~= 0 then
    return namespaces
  end

  if #out == 0 then
    log("could not find any namespaces in this cluster")
    return
  end

  log(out)
end

local function get_config_maps(kubeconfig, namespace)
  local out = vim.fn.system(string.format(
    get_config_maps_cmd, namespace, kubeconfig
  ))

  local config_maps = {}
  for s in out:gmatch('configmap/(%g+)') do
    table.insert(config_maps, s)
  end

  if #config_maps ~= 0 then
    return config_maps
  end

  if #out == 0 then
    log("could not find any config-maps in this namespace")
    return
  end

  log(out)
end

local function describe_config_map(kubeconfig, namespace, config_map)
  local out = vim.fn.system(string.format(
    describe_config_map_cmd, config_map, namespace, kubeconfig
  ))

  return out
end

return {
  get_namespaces = get_namespaces,
  get_config_maps = get_config_maps,
  describe_config_map = describe_config_map,
}
