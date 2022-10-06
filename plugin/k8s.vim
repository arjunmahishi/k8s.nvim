if exists('g:loaded_k8s_nvim') | finish | endif

let s:save_cpo = &cpo
set cpo&vim

command! K8sNamespaces lua require('k8s.telescope').namespaces()
command! -nargs=1 K8sConfigMaps lua require('k8s.telescope').config_maps(<f-args>)()
command! -nargs=1 K8sPods lua require('k8s.telescope').pods(<f-args>)()

let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_k8s_nvim = 1
