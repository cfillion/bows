Layout = require './layout'
Socket = require './socket'

ClientCommands = require './client_commands'
ServerCommands = require './server_commands'

class Controller
  constructor: (config) ->
    @socket = new Socket config['server_url'], config['default_rooms']
    @ui = new Layout

    for roomName in config['default_rooms']
      page = @ui.createPage roomName

    @ui.setCurrentPage 0

    @ui.on 'input', (t, p) => @parseUserInput t, p
    @socket.on 'command', (c) => @execServerCommand c

    @socket.on 'connected', => @connected()
    @socket.on 'disconnected', => @disconnected()
    @disconnected()

  parseUserInput: (text, page) ->
    return false if text.length < 1

    if text[0] == '/'
      commandString = text.toLowerCase().substring 1
      parts = commandString.split "\x20"

      command =
        name: parts.shift()
        arguments: parts
    else
      command =
        name: 'msg'
        room: page.identifier
        arguments: [page.identifier, text]

    sender = (command, args...) =>
      @socket.send command, page.identifier, args

    callback = ClientCommands[command.name]

    unless callback? command.arguments, page, this, sender
      page.addError text, 'invalid command'
      return false

    page.clearInput()

    return

  execServerCommand: (command) ->
    callback = ServerCommands[command.name]

    unless callback? command, this
      @ui.createPage(command.room).addError '42', 'broken client'
      return false

  connected: ->
    @ui.statusbar.setStatus ->
      @addIndicator 'Online'

  disconnected: ->
    @ui.statusbar.setStatus ->
      @addError 'Offline'
      @addOngoing "Reconnecting in the background"

module.exports = Controller
