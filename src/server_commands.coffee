Errors = require('./errors').server
Utils = require './utils'

ServerCommands =
  error: (cmd, ctrl) ->
    code = parseInt cmd.arguments[0]
    message = Errors[code] || Errors[0]

    page = ctrl.ui.createPage cmd.room
    input = page.history.hashTable[cmd.key] || ''
    page.addError input, message, code
    page.restoreInput cmd.key

    true

  msg: (cmd, ctrl) ->
    [nick, text] = cmd.arguments
    page = ctrl.ui.createPage cmd.room
    page.addMessage nick, text

    true

  action: (cmd, ctrl) ->
    [nick, text] = cmd.arguments
    page = ctrl.ui.createPage cmd.room
    page.addAction nick, text
    true

  join: (cmd, ctrl) ->
    [nick] = cmd.arguments
    ctrl.ui.createPage(cmd.room).addLine "#{nick} joined #{cmd.room}"
    true

  part: (cmd, ctrl) ->
    [nick, reasonCode, userString] = cmd.arguments

    reason = switch parseInt(reasonCode)
      when 0
        'connection lost'
      when 1
        '"' + Utils.truncate(userString, 50) + '"' if userString.length > 0
      else
        'unknown'

    suffix = if reason then " (#{reason})" else ''
    ctrl.ui.createPage(cmd.room).addLine "#{nick} left #{cmd.room}#{suffix}"
    true

module.exports = ServerCommands
