# k8s.nvim

Neovim plugin that wraps some of the kubectl operations

## Prerequisites

1. You need to have [Telescope installed](https://github.com/nvim-telescope/telescope.nvim#installation)
2. You need [kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl) in your system path
3. The environment variable `KUBECONFIG` should be set. Containing the path to your kube config file
```
export KUBECONFIG=/path/to/config/file
```

## Installation

Use you favorite plugin manager. If you use vim-plug, add this to your `init.vim` / `init.lua`

```vim
Plug 'arjunmahishi/k8s.nvim'
```

## Configuration

```lua
require('k8s').setup {
  kube_config_dir = '/tmp/kubeconfig' -- (optional) Set the directory where the kube config files are present
}
```

## Commands

These are the commands that are available for now. More will be added in the coming weeks

| Command | Description |
|---------|-------------|
| `:K8sNamespaces` | List all the namespaces in the current cluster <br><br>**Telescope actions**<br> `enter` - list all the pods of the namespace <br> `ctrl + c` - list config maps of the namespace |
| `:K8sKubeConfig` | List all the kube config paths in the configured directory<br><br>**Telescope actions**<br> `enter` - set the selected config path as the KUBECONFIG |
| `:K8sConfigMaps <namespace>` | List all the config maps in the given namespace <br><br>**Telescope actions**<br> `enter` - copy the config into a new buffer |
| `:K8sPods <namespace>` | List all the pods in the given namespace <br><br>**Telescope actions**<br> `enter` - copy the pod description into a new buffer |

### Useful key bindings

```lua
vim.api.nvim_set_keymap('n', '<leader>kc', ':K8sKubeConfig<CR>', {})
vim.api.nvim_set_keymap('n', '<leader>kn', ':K8sNamespaces<CR>', {})
```

---

If you have any questions about how to use the plugin or need help
understanding the code, feel free to [create a new discussion](https://github.com/arjunmahishi/k8s.nvim/discussions/new?category=q-a) / [slide
into my DM](https://twitter.com/messages/131552332-131552332?text=Hey)
