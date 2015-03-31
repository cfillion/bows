Errors = require './errors'

ServerCommands =
  error: (args, ctrl) ->
    code = parseInt args[0]
    message = Errors[code] || Errors[0]

    alert "error ##{code}: #{message}"
    true

  msg: (args, ctrl) ->
    [room, nick, text] = args
    ctrl.ui.createPage(room).addMessage nick, text
    true

  action: (args, ctrl) ->
    [room, nick, text] = args
    ctrl.ui.createPage(room).addAction nick, text
    true

module.exports = ServerCommands
