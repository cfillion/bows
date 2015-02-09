setup_dom = ->
  root_node = document.getElementById 'bows-root'
  while last_child = root_node.lastChild
    root_node.removeChild last_child
  return

module.exports =
  setup: (config) ->
    setup_dom()
    return
