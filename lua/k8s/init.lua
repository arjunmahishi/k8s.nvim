local utils = require("k8s.utils")
local telescope = require("k8s.telescope")

SETUP_OPTIONS = {}

local function reload_plugin()
  package.loaded['k8s'] = nil
  print "reloaded flow"
end

local function setup(options)
  SETUP_OPTIONS = options
end

local function pick_config()
  telescope.pick_config(SETUP_OPTIONS.kube_config_dir)()
end

-- if the KUBECONFIG is defined as an env variable, set that as default
if os.getenv('KUBECONFIG') ~= nil then
  utils.set_kube_config(os.getenv('KUBECONFIG'))
end

return {
  reload_plugin = reload_plugin,
  setup = setup,
  pick_config = pick_config,
}
