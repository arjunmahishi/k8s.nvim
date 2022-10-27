local log = require('k8s.log').print

KUBECONFIG = nil

LIST_FILES_CMD = "find %s -type l,f"

local function str_split(s, delimiter)
  local result = {}
  for match in (s..delimiter):gmatch('(.-)'..delimiter) do
    table.insert(result, match);
  end
  return result
end

local function set_kube_config(config)
  KUBECONFIG = config
end

local function get_kube_config()
  return KUBECONFIG
end

local function str_trim(s)
  return (string.gsub(s, "^%s*(.-)%s*$", "%1"))
end

local function list_files(dir)
  local out = vim.fn.system(string.format(LIST_FILES_CMD, dir))
  return str_split(str_trim(out), "\n")
end

return {
  str_split = str_split,
  str_trim = str_trim,
  set_kube_config = set_kube_config,
  get_kube_config = get_kube_config,
  list_files = list_files,
}
