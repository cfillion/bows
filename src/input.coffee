EventEmitter = require './event_emitter'

class Input extends EventEmitter
  process: (input) ->
    if input[0] == '/'
      input = input.substring 1
      parts = input.split "\x20"

      @processCommand parts.shift(), parts
    else
      @processMessage input

    return

  processCommand: (cmd, args) ->
    @emit 'send', cmd, args
    return

  processMessage: (text) ->
    @emit 'send', 'msg', text
    return

module.exports = Input
