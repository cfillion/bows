EventEmitter = require './event_emitter'

Command = require './command'
Utils = require './utils'

class Socket extends EventEmitter
  constructor: (serverUrl) ->
    @serverUrl = serverUrl

    @socket = new WebSocket serverUrl
    @socket.onopen = => @onopen()
    @socket.onmessage = (event) => @onmessage event.data
    @socket.onclose = => @onclose()

  onopen: ->
    @send 'msg', '#hello_world', 'hello'
    return

  onmessage: (text) ->
    commands = Command.unserialize text

    for command in commands
      @emit 'command', command

    return

  onclose: ->
    return

  send: (commands, args...) ->
    if Utils.isString commands
      commands = new Command commands, args

    unless Utils.isArray commands
      commands = [commands]

    text = Command.serialize commands

    if text
      @socket.send text
      true
    else
      false

module.exports = Socket
