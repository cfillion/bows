Utils = require './utils'

MESSAGE_SEPARATOR = '\x1E'
PART_SEPARATOR = "\x1F"

class Message
  @serialize: (messages) ->
    serializedMessages = []

    for message in messages
      serializedMessages.push message.serialize()

    serializedMessages.join MESSAGE_SEPARATOR

  @unserialize: (serializedMessages) ->
    messages = []
    splitted = serializedMessages.split MESSAGE_SEPARATOR

    for messageContents in splitted
      parts = messageContents.split PART_SEPARATOR

      messages.push new Message(parts.shift(), parts)

    messages

  @isValid: (string) ->
    !Utils.contains(string, MESSAGE_SEPARATOR) &&
      !Utils.contains(string, PART_SEPARATOR)

  constructor: (cmd, args = []) ->
    unless Utils.isArray args
      args = [args]

    @command = cmd
    @arguments = args

  serialize: ->
    parts = @arguments
    parts.unshift @command

    parts.join PART_SEPARATOR

  toString: ->
    parts = ["CMD #{@command}"]

    for argument in @arguments
      parts.push "ARG #{argument}"

    parts.join "\x20"

module.exports = Message
