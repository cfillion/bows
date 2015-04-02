Errors = require('./errors').Client

validateArguments = (args, min, max = null) ->
  max = min unless max

  return Errors.MISSING_ARGUMENTS if args.length < min

  # the upper limit check is bypassed if 'max' is a negative number
  return Errors.EXTRA_ARGUMENTS if args.length > max && max > 0

  false

ClientCommands =
  msg: (args, page, ctrl, send) ->
    return error if error = validateArguments args, 2

    [room, text...] = args
    text = text.join "\x20"

    send 'msg', room, text

  me: (args, page, ctrl, send) ->
    return error if error = validateArguments args, 1

    text = args.join "\x20"
    send 'action', page.identifier, text

  join: (args, page, ctrl, send) ->
    return error if error = validateArguments args, 1

    room = args.join "\x20"
    send 'join', room

  clear: (args, page, ctrl, send) ->
    return error if error = validateArguments args, 0

    page.clear()
    true

  close: (args, page, ctrl, send) ->
    return error if error = validateArguments args, 0

    ctrl.ui.closePage page
    true

module.exports = ClientCommands
