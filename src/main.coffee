Layout = require './layout'
Socket = require './socket'

module.exports =
  setup: (config) ->
    ui = new Layout
    socket = new Socket config['server_url']

    socket.on 'message', (m) -> ui.addMessage m
    ui.on 'send', (m) -> socket.send m

    return
