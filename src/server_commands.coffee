Errors = require './errors'

ServerCommands =
  error: (cmd, ctrl) ->
    code = parseInt cmd.arguments[0]
    message = Errors[code] || Errors[0]

    ctrl.ui.createPage(cmd.room).addError cmd.key, message, code
    true

  msg: (cmd, ctrl) ->
    [nick, text] = cmd.arguments
    ctrl.ui.createPage(cmd.room).addMessage nick, text
    true

  action: (cmd, ctrl) ->
    [nick, text] = cmd.arguments
    ctrl.ui.createPage(cmd.room).addAction nick, text
    true

module.exports = ServerCommands
