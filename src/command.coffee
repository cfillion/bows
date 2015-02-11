Utils = require './utils'

COMMAND_SEPARATOR = '\x1E'
PART_SEPARATOR = "\x1F"

class Command
  @serialize: (commands) ->
    textParts = []

    for command in commands
      textParts.push command.serialize()

    textParts.join COMMAND_SEPARATOR

  @unserialize: (text) ->
    commands = []

    splitted = text.split COMMAND_SEPARATOR

    for commandText in splitted
      parts = commandText.split PART_SEPARATOR

      commands.push new Command(parts.shift(), parts)

    commands

  @isValid: (string) ->
    !Utils.contains(string, COMMAND_SEPARATOR) &&
      !Utils.contains(string, PART_SEPARATOR)

  constructor: (cmdName, args = []) ->
    unless Utils.isArray args
      args = [args]

    @name = cmdName
    @arguments = args

  serialize: ->
    parts = @arguments
    parts.unshift @name

    parts.join PART_SEPARATOR

  toString: ->
    parts = ["CMD #{@name}"]

    for argument in @arguments
      parts.push "ARG #{argument}"

    parts.join "\x20"

module.exports = Command
