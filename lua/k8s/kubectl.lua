local json = require('k8s.lib.json')
local log = require('k8s.log').print
local utils = require('k8s.utils').print

KUBECONFIG_DIR = nil

-- list namespaces
local get_namespaces_cmd = 'kubectl get namespaces -o name --kubeconfig %s'

-- get resources: the first %s is for interpolating either --namespace=x / --all-namespaces
local get_config_maps_cmd = 'kubectl get configmaps %s -o name --kubeconfig %s'
-- local get_config_maps_cmd = 'kubectl get configmaps --all-namespaces -o json'
local get_pods_cmd = 'kubectl get pods --namespace %s -o name --kubeconfig %s'

-- describe resources
local describe_config_map_cmd = 'kubectl get configmaps %s --namespace %s -o jsonpath="{.data.config}" --kubeconfig %s'
local describe_pod_cmd = 'kubectl describe pod %s --namespace %s --kubeconfig %s'

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
  local namespace_flag = '--all-namespaces'
  if namespace ~= nil then
    namespace_flag = string.format('--namespace %s', namespace)
  end

  local out = vim.fn.system(string.format(
    get_config_maps_cmd, namespace_flag, kubeconfig
  ))

  local config_maps = {}
  for s in out:gmatch('%g/(%g+)') do
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

local function get_pods(kubeconfig, namespace)
  local out = vim.fn.system(string.format(
    get_pods_cmd, namespace, kubeconfig
  ))

  local pods = {}
  for s in out:gmatch('pod/(%g+)') do
    table.insert(pods, s)
  end

  if #pods ~= 0 then
    return pods
  end

  if #out == 0 then
    log("could not find any pods in this namespace")
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

local function describe_pod(kubeconfig, namespace, pod)
  local out = vim.fn.system(string.format(
    describe_pod_cmd, pod, namespace, kubeconfig
  ))

  return out
end

return {
  get_namespaces = get_namespaces,
  get_config_maps = get_config_maps,
  describe_config_map = describe_config_map,
  get_pods = get_pods,
  describe_pod = describe_pod,
}
