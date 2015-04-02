Errors = require('./errors').Server

ServerCommands =
  error: (cmd, ctrl) ->
    code = parseInt cmd.arguments[0]
    message = Errors[code] || Errors[0]

    page = ctrl.ui.createPage cmd.room
    page.addError cmd.key, message, code
    page.restoreInput cmd.key

    true

  msg: (cmd, ctrl) ->
    [nick, text] = cmd.arguments
    ctrl.ui.createPage(cmd.room).addMessage nick, text
    true

  action: (cmd, ctrl) ->
    [nick, text] = cmd.arguments
    ctrl.ui.createPage(cmd.room).addAction nick, text
    true

  join: (cmd, ctrl) ->
    [nick] = cmd.arguments
    ctrl.ui.createPage(cmd.room).addLine "#{nick} joined #{cmd.room}"
    true

  part: (cmd, ctrl) ->
    [nick] = cmd.arguments
    ctrl.ui.createPage(cmd.room).addLine "#{nick} left #{cmd.room}"
    true

module.exports = ServerCommands
