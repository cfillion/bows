EventEmitter = require './event_emitter'

class Input extends EventEmitter
  process: (input) ->
    return if input.length < 1

    if input[0] == '/'
      input = input.substring 1
      parts = input.split "\x20"

      @processCommand parts.shift(), parts
    else
      @processMessage input

    return

  processCommand: (cmd, args) ->
    # TODO: do something with cmd instead of sending it raw to the server
    @emit 'send', cmd, args
    return

  processMessage: (text) ->
    @emit 'send', 'msg', text
    return

module.exports = Input
