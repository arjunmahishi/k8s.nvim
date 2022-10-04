local log = require('k8s.log').print
-- local str_split = require('k8s.utils').str_split

local getNamespacesCmd = "kubectl get namespaces -o name --kubeconfig %s"

local function getNamespaces(kubeconfig)
  local out = vim.fn.system(string.format(getNamespacesCmd, kubeconfig))

  local namespaces = {}
  for s in out:gmatch('namespace/(%g+)') do
    table.insert(namespaces, s)
  end

  if #namespaces ~= 0 then
    return namespaces
  end

  log(out)
end

-- print(vim.inspect(getNamespaces(os.getenv('KUBECONFIG'))))

return {
  getNamespaces = getNamespaces
}
