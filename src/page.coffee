EventEmitter = require './event_emitter'

Utils = require './utils'

hash = require 'string-hash'

MSG_COLOR_COUNT = 36

LINE_DEFAULT = 0
LINE_ERROR = 1

class Page extends EventEmitter
  constructor: (identifier) ->
    @node = Utils.createNode 'div', 'page'

    @messages = Utils.createNode 'div', 'messages'
    @node.appendChild @messages

    @input = Utils.createNode 'textarea', 'input'
    @input.placeholder = 'Type your message here...'
    @input.onkeypress = (event) => @onInput event.keyCode

    @node.appendChild @input

    @identifier = identifier
    @setName identifier

    @alertCount = 0
    @hasFocus = false

    window.addEventListener 'resize', => @onResize()

  setName: (newName) ->
    @name = newName
    @emit 'nameChanged', newName

    return

  onInput: (keyCode) ->
    switch keyCode
      when 13
        @emit 'input', @input.value
      else
        return true

    return false

  onResize: ->
    Utils.scrollToBottom @messages
    return

  focus: ->
    Utils.addClass 'current', @node
    Utils.scrollToBottom @messages

    @resetAlerts()
    @input.focus()
    @hasFocus = true

    return

  blur: ->
    Utils.removeClass 'current', @node

    @hasFocus = false
    @addSeparator()

    return

  clearInput: ->
    @input.value = ''
    return

  addMessage: (nick, text) ->
    @addLine "#{nick}: #{text}", nick

  addAction: (nick, text) ->
    @addLine "* #{nick} #{text}", nick

  addError: (source, cause) ->
    @addLine "#{source} → #{cause}", LINE_ERROR

  addLine: (text, group = 0) ->
    switch group
      when LINE_DEFAULT
        klass = 'color0'
      when LINE_ERROR
        klass = 'error'
      else
        colorId = hash(group) % MSG_COLOR_COUNT
        klass = "color#{colorId + 1}"

    timeNode = document.createTextNode Utils.currentTimeString()
    textNode = document.createTextNode text

    timeContainer = Utils.createNode 'span', 'time'
    timeContainer.appendChild timeNode

    textContainer = Utils.createNode 'span', 'text'
    textContainer.appendChild textNode

    container = Utils.createNode 'p', ['message', klass]
    container.appendChild timeContainer
    container.appendChild Utils.nodeSeparator()
    container.appendChild textContainer

    wasAtBottom = Utils.isNearBottom @messages
    @messages.appendChild container
    Utils.scrollToBottom @messages if wasAtBottom

    @alert() unless @hasFocus

    return

  addSeparator: ->
    separator = Utils.createNode 'hr'
    @messages.appendChild separator

    return

  alert: ->
    @emit 'alertCountChanged', ++@alertCount
    return

  resetAlerts: ->
    @alertCount = -1
    @alert()

    return

module.exports = Page
