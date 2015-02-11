Input = require './input'
Layout = require './layout'
Socket = require './socket'

module.exports =
  setup: (config) ->
    input = new Input
    socket = new Socket config['server_url']
    ui = new Layout

    input.on 'send', (m, a) ->
      socket.send m, a
      ui.clearInput()

    socket.on 'command', (c) -> ui.addMessage c # TODO: execute the command
    ui.on 'input', (m) -> input.process m

    return
