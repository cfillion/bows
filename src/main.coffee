DOM = {}

setup_dom = ->
  root_node = document.getElementById 'bows-root'

  while last_child = root_node.lastChild
    root_node.removeChild last_child

  DOM.messages = document.createElement 'div'
  DOM.messages.id = 'bows-messages'
  root_node.appendChild DOM.messages

  DOM.input = document.createElement 'textarea'
  DOM.input.id = 'bows-input'
  DOM.input.placeholder = '[Input zone]'
  root_node.appendChild DOM.input

  DOM.input.onkeypress = (event) ->
    switch event.keyCode
      when 13
        alert "sending #{DOM.input.value}"
        DOM.input.value = ''
      else
        return true

    return false

  return

setup_websocket = (server_url) ->
  socket = new WebSocket server_url

  socket.onopen = ->
    socket.send 'hello'
    return

  socket.onmessage = (event) ->
    text_node = document.createTextNode event.data
    DOM.messages.appendChild text_node
    return

  return

module.exports =
  setup: (config) ->
    setup_dom()
    setup_websocket config['server_url']

    return
