SCROLL_THRESHOLD = 20 # affects isNearBottom

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

  isString: (variable) ->
    typeof variable == 'string'

  isArray: (variable) ->
    Array.isArray variable

  contains: (search, string) ->
    string.indexOf(search) != -1

  truncate: (string, maxLength) ->
    if string.length > maxLength
      string = string.substring 0, maxLength - 1
      string += '…'

    return string

  prefix: (identifier) ->
    "bows-#{identifier}"

  addClass: (klass, node) ->
    klass = @prefix klass
    node.classList.add klass

    return

  removeClass: (klass, node) ->
    klass = @prefix klass
    node.classList.remove klass

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

  isNearBottom: (node) ->
    node.scrollTop + node.clientHeight >= node.scrollHeight - SCROLL_THRESHOLD

  scrollToBottom: (node) ->
    node.scrollTop = node.scrollHeight
    return

  show: (node) ->
    @removeClass 'hidden', node
    return

  hide: (node) ->
    @addClass 'hidden', node
    return

  truncateNode: (node, threshold = 3000) ->
    while node.childElementCount > threshold
      node.removeChild node.firstChild

    return

  nodeSeparator: ->
    document.createTextNode "\x20"

  closeButton: ->
    button = @createNode 'span', 'close'
    button.appendChild document.createTextNode("\u00D7")
    button

  cssValue: (property, node) ->
    style = window.getComputedStyle node
    style.getPropertyValue property

  windowWidth: ->
    document.body.clientWidth

  windowHeight: ->
    document.body.clientHeight

module.exports = Utils
