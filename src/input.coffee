EventEmitter = require './event_emitter'

class Input extends EventEmitter
  processText: (text) ->
    return if text.length < 1

    if text[0] == '/'
      text = text.substring 1
      parts = text.split "\x20"

      @processCommand parts.shift(), parts
    else
      @processMessage text

    return

  processCommand: (cmdName, args) ->
    # TODO: do something with cmd instead of sending it raw to the server
    @emit 'send', cmdName, args
    return

  processMessage: (text) ->
    @emit 'send', 'msg', text
    return

module.exports = Input
