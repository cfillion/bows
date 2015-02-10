EventEmitter = require './event_emitter'

class Input extends EventEmitter
  process: (input) ->
    @emit 'send', input
    return

module.exports = Input
