EventEmitter = require './event_emitter'

Command = require './command'
Errors = require('./errors').Client
Utils = require './utils'

class Socket extends EventEmitter
  constructor: (serverUrl, defaultRooms) ->
    @serverUrl = serverUrl

    @attemps = 0
    @queue = []

    @open()

  open: ->
    @socket = new WebSocket @serverUrl
    @socket.onopen = => @onopen()
    @socket.onmessage = (event) => @onmessage event.data
    @socket.onclose = => @onclose()

  onopen: ->
    @emit 'connected'
    @attemps = 0

    while @queue.length > 0
      message = @queue.shift()
      @socket.send message

    @send 'msg', '#hello_world',
      ['#hello_world', 'hello']

    return

  onmessage: (text) ->
    commands = Command.unserialize text

    for command in commands
      @emit 'command', command

    return

  onclose: ->
    @emit 'disconnected'

    maxDelay = Math.pow 2, @attemps
    seconds = Math.min 30, maxDelay

    retryDelay = Math.random() * (seconds * 1000)
    setTimeout (=> @attemps++; @open()), retryDelay

    return

  send: (commands, roomName, args) ->
    if Utils.isString commands
      commands = new Command commands, roomName, args

    unless Utils.isArray commands
      commands = [commands]

    text = Command.serialize commands
    return Errors.SERIALIZATION_FAILED unless text

    if @socket.readyState == WebSocket.OPEN
      @socket.send text
    else
      @queue.shift if @queue.length > 50
      @queue.push text

    true

module.exports = Socket
