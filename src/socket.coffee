EventEmitter = require './event_emitter'

class Socket extends EventEmitter
  constructor: (server_url) ->
    @server_url = server_url

    @socket = new WebSocket server_url
    @socket.onopen = => @onopen()
    @socket.onmessage = (event) => @onmessage event.data

  onopen: ->
    @socket.send 'hello world'
    return
  
  onmessage: (serialized_message) ->
    @emit 'message', serialized_message
    return

  send: (message) ->
    @socket.send message
    return

module.exports = Socket
