EventEmitter = require './event_emitter'

Command = require './command'
Utils = require './utils'

class Socket extends EventEmitter
  constructor: (serverUrl, defaultRooms) ->
    @serverUrl = serverUrl
    @loginRooms = defaultRooms

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

    for room in @loginRooms
      @send 'join', room

    while @queue.length > 0
      message = @queue.shift()
      @socket.send message

    @send 'msg', '#hello_world', 'hello'
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

  send: (commands, args...) ->
    if Utils.isString commands
      commands = new Command commands, args

    unless Utils.isArray commands
      commands = [commands]

    text = Command.serialize commands
    return false unless text

    if @socket.readyState == WebSocket.OPEN
      @socket.send text
    else
      @queue.push text

    true

module.exports = Socket
