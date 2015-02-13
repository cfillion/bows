Utils =
  currentTimeString: ->
    date = new Date

    hours = @padLeft date.getHours(), '0', 2
    minutes = @padLeft date.getMinutes(), '0', 2
    seconds = @padLeft date.getSeconds(), '0', 2

    "#{hours}:#{minutes}:#{seconds}"

  padLeft: (input, pad, length) ->
    input = input.toString()

    while input.length < length
      input = pad + '' + input

    input

  nodeSeparator: ->
    document.createTextNode "\x20"

  isString: (variable) ->
    typeof variable == 'string'

  isArray: (variable) ->
    Array.isArray variable

  contains: (string, search) ->
    string.indexOf(search) != -1

  prefix: (identifier) ->
    "bows-#{identifier}"

  addClass: (klass, node) ->
    klass = @prefix klass

    if node.className
      node.className += "\x20#{klass}"
    else
      node.className = klass

    return

  removeClass: (klass, node) ->
    klass = @prefix klass

    klasses = node.className.split "\x20"
    index = klasses.indexOf(klass)

    if index > -1
      klasses.splice index, 1

    node.className = klasses.join "\x20"

    return

  createNode: (type, klasses = []) ->
    klasses = [klasses] unless @isArray klasses

    node = document.createElement type
    @addClass klass, node for klass in klasses

    node

  clearNode: (node) ->
    while last_child = node.lastChild
      node.removeChild last_child

    return

  closeButton: ->
    button = @createNode 'span', 'close'
    button.appendChild document.createTextNode("\u00D7")
    button

module.exports = Utils
