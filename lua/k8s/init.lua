local default_setup_options = {
  output = {
    buffer = false
  }
}

SETUP_OPTIONS = default_setup_options

local function reload_plugin()
  package.loaded['k8s'] = nil
  print "reloaded flow"
end

local function setup(options)
  SETUP_OPTIONS = options
end

return {
  reload_plugin = reload_plugin,
  setup = setup
}
