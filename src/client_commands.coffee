ClientCommands =
  msg: (args, page, ctrl) ->
    [room, text...] = args
    text = text.join "\x20"

    return false if room.length < 1 || text.length < 1

    ctrl.socket.send 'msg', page.identifier,
      [room, text]

  me: (args, page, ctrl) ->
    text = args.join "\x20"

    return false if text.length < 1

    ctrl.socket.send 'action', page.identifier,
      [page.identifier, text]

  join: (args, page, ctrl) ->
    room = args.join "\x20"

    ctrl.socket.send 'join', page.identifier,
      [room]

  clear: (args, page, ctrl) ->
    page.clear()
    true

  close: (args, page, ctrl) ->
    ctrl.ui.closePage page
    true

module.exports = ClientCommands
