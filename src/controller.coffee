Layout = require './layout'
Socket = require './socket'

ClientCommands = require './client_commands'
ServerCommands = require './server_commands'

class Controller
  constructor: (config) ->
    @socket = new Socket config['server_url']
    @ui = new Layout

    for roomName in config['default_rooms']
      page = @ui.createPage roomName

    @ui.setCurrentPage 0

    @ui.on 'input', (t, p) => @parseUserInput t, p
    @socket.on 'command', (c) => @execServerCommand c

  parseUserInput: (text, page) ->
    return if text.length < 1

    if text[0] == '/'
      text = text.substring 1
      parts = text.split "\x20"

      command =
        name: parts.shift()
        arguments: parts
    else
      command =
        name: 'msg'
        arguments: [page.identifier, text]

    callback = ClientCommands[command.name]

    unless callback? command.arguments, page, this
      alert 'invalid command'
      return false

    page.clearInput()

    return

  execServerCommand: (command) ->
    callback = ServerCommands[command.name]

    unless callback? command.arguments, this
      alert 'unsupported command received!'
      return false

module.exports = Controller
