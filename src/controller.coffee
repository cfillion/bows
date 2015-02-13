Layout = require './layout'
Socket = require './socket'

class Controller
  constructor: (config) ->
    @socket = new Socket config['server_url']
    @ui = new Layout

    for roomName in config['default_rooms']
      page = @ui.createPage roomName
      page.on 'input', (t) => @userInput t, page

    @ui.setCurrentPage 0

    @socket.on 'command', (c) => @serverCommands c

  userInput: (text, page) ->
    return if text.length < 1

    if text[0] == '/'
      text = text.substring 1
      parts = text.split "\x20"

      @clientCommands parts.shift(), parts
    else
      @socket.send 'msg', text

    return

  clientComments: (cmdName, args) ->
    # TODO: do something with cmd instead of sending it raw to the server
    @socket.send cmdName, args
    return

  serverCommands: (command) ->
    switch command.name
      when 'msg' then @ui.createPage(command.argument 1).addMessage command
      else alert 'invalid command received!'

module.exports = Controller
