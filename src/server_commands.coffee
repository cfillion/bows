ServerCommands =
  msg: (args, ctrl) ->
    [room, nick, text] = args
    ctrl.ui.createPage(room).addMessage nick, text
    true

module.exports = ServerCommands
