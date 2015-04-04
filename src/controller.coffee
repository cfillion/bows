Command = require './command'
Errors = require('./errors').Client
Layout = require './layout'
Socket = require './socket'
Utils = require './utils'

ClientCommands = require './client_commands'
ServerCommands = require './server_commands'

class Controller
  constructor: (config) ->
    @socket = new Socket config['server_url']
    @ui = new Layout

    for roomName in config['default_rooms']
      page = @ui.createPage roomName, true
      @ui.setClosable page, false

    @ui.setCurrentPage 0

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
    # (re)join opened rooms
    for page in @ui.pages when page.isRoom
      @socket.send 'join', page.identifier, [page.identifier]

    @ui.statusbar.setStatus ->
      @addIndicator 'Online'

  disconnected: ->
    @ui.statusbar.setStatus ->
      @addError 'Offline'
      @addOngoing "Reconnecting in the background"

module.exports = Controller
