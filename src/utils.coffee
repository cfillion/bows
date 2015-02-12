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

  closeButton: ->
    button = document.createElement 'span'
    button.className = 'bows-close'
    button.appendChild document.createTextNode("\u00D7")
    button

  addClass: (klass, node) ->
    if node.className
      node.className += "\x20#{klass}"
    else
      node.className = klass

  removeClass: (klass, node) ->
    klasses = node.className.split "\x20"
    index = klasses.indexOf(klass)

    if index > -1
      klasses.splice index, 1

    node.className = klasses.join "\x20"

module.exports = Utils
