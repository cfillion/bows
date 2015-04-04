EventEmitter = require './event_emitter'

hash = require 'string-hash'

class History extends EventEmitter
  constructor: ->
    @stack = []
    @hashTable = {}
    @currentPosition = 0

  move: (steps, originalInput) ->
    @moveTo @currentPosition - steps, originalInput

  moveTo: (position, originalInput) ->
    text = @stack[@stack.length - position]

    text = @originalInput if position == 0
    return if text == undefined

    @originalInput = originalInput if @currentPosition == 0
    @currentPosition = position
    @emit 'changed', text

    return

  push: (text) ->
    return unless text

    hashValue = hash text

    hashes = Object.keys @hashTable
    delete @hashTable[hashes[0]] if hashes.length > 5
    @hashTable[hashValue] = text

    @stack.shift() if @stack.length > 50
    @stack.push text

    console.log @hashTable
    console.log @stack

    @currentPosition = 0
    @lastHash = hashValue

  restore: (key, originalInput) ->
    key = @lastHash unless key

    text = @hashTable[key]
    return if text == undefined

    index = @stack.indexOf text
    if index == -1
      @push originalInput
      @emit 'changed', text
    else
      @moveTo @stack.length - index, originalInput

module.exports = History
