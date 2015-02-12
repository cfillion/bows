EventEmitter = require './event_emitter'

Input = require './input'
Layout = require './layout'
Socket = require './socket'

class Controller extends EventEmitter
  constructor: (config) ->
    @input = new Input
    @socket = new Socket config['server_url']
    @ui = new Layout

    @input.on 'send', (m, a) =>
      @socket.send m, a
      @ui.clearInput()

    @socket.on 'command', (c) => @executeCommand c
    @ui.on 'input', (t) => @input.processText t

  executeCommand: (command) ->
    switch command.name
      when 'msg' then @ui.addMessage command
      else alert 'invalid command received!'

module.exports = Controller
