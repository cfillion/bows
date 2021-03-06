Command = require './command'
Errors = require('./errors').client
Layout = require './layout'
Socket = require './socket'
Utils = require './utils'

ClientCommands = require './client_commands'
ServerCommands = require './server_commands'

class Controller
  constructor: (config) ->
    @ui = new Layout

    @pinnedRooms = config['default_rooms']
    for room in @pinnedRooms
      page = @ui.createPage room, true
      @ui.setClosable page, false

    @ui.setCurrentPage 0

    @socket = new Socket config['server_url']

    @ui.on 'input', (t, p) => @parseUserInput t, p
    @socket.on 'command', (c) => @execServerCommand c

    @socket.on 'connected', => @connected()
    @socket.on 'disconnected', => @disconnected()
    @disconnected()

    @ui.on 'pageClosed', (p) =>
      @socket.send 'part', p.identifier, p.identifier if p.isRoom

  parseUserInput: (text, page) ->
    return false if text.length < 1

    if text[0] == '/'
      commandString = text.toLowerCase().substring 1
      parts = commandString.match(/[^\x20]+/g) || []

      command =
        name: parts.shift()
        arguments: parts
    else
      command =
        name: 'msg'
        room: page.identifier
        arguments: [page.identifier, text]

    sender = (cmdName, args...) =>
      command = new Command cmdName, page.identifier, args
      command.key = page.history.lastHash
      @socket.send command

    callback = ClientCommands[command.name]
    value = callback? command.arguments, page, this, sender

    if callback == undefined
      page.addError text, Errors.COMMAND_NOT_FOUND
    else if !value
      page.addError text, Errors.UNKNOWN_ERROR
    else if Utils.isString value
      page.addError text, value
    else
      return

    page.restoreInput()

    return

  execServerCommand: (command) ->
    callback = ServerCommands[command.name]

    unless callback? command, this
      page = @ui.createPage command.room
      page.addError command.toString(), Errors.BROKEN_CLIENT
      return false

  connected: ->
    for room in @pinnedRooms
      @socket.send 'join', room, [room]

    @ui.statusbar.setStatus ->
      @addIndicator 'Online'

    return

  disconnected: ->
    @ui.statusbar.setStatus ->
      @addError 'Offline'
      @addOngoing "Reconnecting in the background"

    return

  pinRoom: (room) ->
    @pinnedRooms.push room unless Utils.contains room, @pinnedRooms
    return

  unpinRoom: (room) ->
    index = @pinnedRooms.indexOf room
    @pinnedRooms.splice index, 1 if index != -1
    return

module.exports = Controller
