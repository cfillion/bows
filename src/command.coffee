Utils = require './utils'

COMMAND_SEPARATOR = '\x1E'
PART_SEPARATOR = "\x1F"

class Command
  @serialize: (commands) ->
    textParts = []

    for command in commands
      return false unless command.isValid()
      textParts.push command.serialize()

    textParts.join COMMAND_SEPARATOR

  @unserialize: (text) ->
    commands = []

    splitted = text.split COMMAND_SEPARATOR

    for commandText in splitted
      parts = commandText.split PART_SEPARATOR

      commands.push new Command(parts.shift(), parts.shift(), parts)

    commands

  constructor: (cmdName, roomName, args = []) ->
    unless Utils.isArray args
      args = [args]

    @name = cmdName
    @room = roomName
    @arguments = args

  serialize: ->
    parts = @arguments
    parts.unshift @room
    parts.unshift @name

    parts.join PART_SEPARATOR

  toString: ->
    parts = ["CMD #{@name}", "IN #{@room}"]

    for argument in @arguments
      parts.push "ARG #{argument}"

    parts.join "\x20"

  argument: (index) ->
    @arguments[index] || ''

  containsSeparators: (string) ->
    Utils.contains(string, COMMAND_SEPARATOR) ||
      Utils.contains(string, PART_SEPARATOR)

  isValid: ->
    return false if @containsSeparators @name

    for argument in @arguments
      return false if @containsSeparators argument

    true

module.exports = Command
