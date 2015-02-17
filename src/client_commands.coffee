ClientCommands =
  msg: (args, page, ctrl) ->
    [room, text...] = args
    text = text.join "\x20"

    return false if room.length < 1 || text.length < 1

    ctrl.socket.send 'msg', room, text

  me: (args, page, ctrl) ->
    text = args.join "\x20"

    return false if text.length < 1

    ctrl.socket.send 'action', page.identifier, text

  close: (cmd, page, ctrl) ->
    ctrl.ui.closePage page
    true

module.exports = ClientCommands
