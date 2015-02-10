EventEmitter = require './event_emitter'
Message = require './message'
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

  onmessage: (serializedMessages) ->
    messages = Message.unserialize serializedMessages

    for message in messages
      @emit 'message', message

    return

  send: (messages, args = []) ->
    if Utils.isString messages
      messages = new Message messages, args

    unless Utils.isArray messages
      messages = [messages]

    @socket.send Message.serialize(messages)
    return

module.exports = Socket
