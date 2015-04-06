Errors = require('./errors').client

validateArguments = (args, min, max = null) ->
  max = min unless max

  return Errors.MISSING_ARGUMENTS if args.length < min

  # the upper limit check is bypassed if 'max' is a negative number
  return Errors.EXTRA_ARGUMENTS if args.length > max && max > -1

  false

ClientCommands =
  msg: (args, page, ctrl, send, expect) ->
    return error if error = validateArguments args, 2, -1

    [room, text...] = args
    text = text.join "\x20"

    ctrl.ui.delayFocus room
    send 'msg', room, text

  me: (args, page, ctrl, send) ->
    return error if error = validateArguments args, 1, -1

    text = args.join "\x20"
    send 'action', page.identifier, text

  join: (args, page, ctrl, send, expect) ->
    return error if error = validateArguments args, 0, 1
    room = args[0] || page.identifier

    ctrl.ui.delayFocus room
    send 'join', room

  part: (args, page, ctrl, send) ->
    room = (args.shift() if args[0] && args[0][0] == '#') || page.identifier
    send 'part', room, args.join("\x20")

  clear: (args, page) ->
    return error if error = validateArguments args, 0

    page.clear()
    true

  close: (args, page, ctrl) ->
    return error if error = validateArguments args, -1

    if args.length == 0
      return Errors.PERMANENT_PAGE unless ctrl.ui.isClosable page
      ctrl.ui.closePage page
      return true

    pages = []

    for arg in args
      page = ctrl.ui.findPage arg

      if !page
        return Errors.PAGE_NOT_FOUND
      else if !ctrl.ui.isClosable page
        return Errors.PERMANENT_PAGE
      else
        pages.push page

    ctrl.ui.closePage p for p in pages

    true

module.exports = ClientCommands
