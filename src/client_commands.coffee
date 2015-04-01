ClientCommands =
  msg: (args, page, ctrl, send) ->
    [room, text...] = args
    text = text.join "\x20"

    return false if room.length < 1 || text.length < 1

    send 'msg', room, text

  me: (args, page, ctrl, send) ->
    text = args.join "\x20"

    return false if text.length < 1

    send 'action', page.identifier, text

  join: (args, page, ctrl, send) ->
    room = args.join "\x20"

    send 'join', room

  clear: (args, page, ctrl, send) ->
    page.clear()
    true

  close: (args, page, ctrl, send) ->
    ctrl.ui.closePage page
    true

module.exports = ClientCommands
