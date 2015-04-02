Errors = require('./errors').Client

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
    return error if error = validateArguments args, 1

    ctrl.ui.delayFocus args[0]
    send 'join', args[0]

  part: (args, page, ctrl, send) ->
    return error if error = validateArguments args, 1
    send 'part', args[0]

  clear: (args, page) ->
    return error if error = validateArguments args, 0

    page.clear()
    true

  close: (args, page, ctrl) ->
    return error if error = validateArguments args, -1

    if args.length == 0
      ctrl.ui.closePage page
      return true

    pages = []

    for arg in args
      if page = ctrl.ui.findPage(arg)
        pages.push page
      else
        return Errors.PAGE_NOT_FOUND

    ctrl.ui.closePage p for p in pages

    true

module.exports = ClientCommands
