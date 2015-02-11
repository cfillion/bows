EventEmitter = require './event_emitter'

Command = require './command'
Utils = require './utils'

class Socket extends EventEmitter
  constructor: (serverUrl) ->
    @serverUrl = serverUrl

    @socket = new WebSocket serverUrl
    @socket.onopen = => @onopen()
    @socket.onmessage = (event) => @onmessage event.data

  onopen: ->
    @socket.send 'hello world'
    return

  onmessage: (text) ->
    commands = Command.unserialize text

    for command in commands
      @emit 'command', command

    return

  send: (commands, args = []) ->
    if Utils.isString commands
      commands = new Command commands, args

    unless Utils.isArray commands
      commands = [commands]

    @socket.send Command.serialize(commands)
    return

module.exports = Socket
