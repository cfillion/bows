Utils = require './utils'

COMMAND_SEPARATOR = '\x1E'
PART_SEPARATOR = '\x1F'

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

      name = parts.shift()
      key = parts.shift()
      room = parts.shift()

      command = new Command(name, room, parts)
      command.key = key
      commands.push command

    commands

  constructor: (cmdName, roomName, args = []) ->
    unless Utils.isArray args
      args = [args]

    @name = cmdName
    @key = ''
    @room = roomName
    @arguments = args

  serialize: ->
    parts = @arguments
    parts.unshift @room
    parts.unshift @key
    parts.unshift @name

    parts.join PART_SEPARATOR

  toString: ->
    parts = ["CMD #{@name}", "KEY #{@key}", "IN #{@room}"]

    for argument in @arguments
      parts.push "ARG #{argument}"

    parts.join "\x20"

  argument: (index) ->
    @arguments[index] || ''

  containsIllegal: (string) ->
    # detects ASCII control characters
    # see http://en.wikipedia.org/wiki/ASCII#ASCII_control_code_chart

    for char in string.split ''
      code = char.charCodeAt 0
      continue if Utils.contains char, "\r\n\t"
      return true if code <= 0x1F || code == 0x7F

    false

  isValid: ->
    return false if @containsIllegal @name

    for argument in @arguments
      return false if @containsIllegal argument

    true

module.exports = Command
