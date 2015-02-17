EventEmitter = require './event_emitter'

Utils = require './utils'

hash = require 'string-hash'

MSG_COLOR_COUNT = 36

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
    Utils.scrollToBottom @messages
    @resetAlerts()

    @input.focus()

    return

  clearInput: ->
    @input.value = ''
    return

  addMessage: (nick, text) ->
    @addLine "#{nick}: #{text}", nick

  addAction: (nick, text) ->
    @addLine "* #{nick} #{text}", nick

  addLine: (text, group = null) ->
    colorCode = 0
    colorCode = (hash(group) % MSG_COLOR_COUNT) + 1 if group

    timeNode = document.createTextNode Utils.currentTimeString()
    textNode = document.createTextNode text

    timeContainer = Utils.createNode 'span', 'time'
    timeContainer.appendChild timeNode

    textContainer = Utils.createNode 'span', 'text'
    textContainer.appendChild textNode

    container = Utils.createNode 'p', ['message', "color#{colorCode}"]
    container.appendChild timeContainer
    container.appendChild Utils.nodeSeparator()
    container.appendChild textContainer

    wasAtBottom = Utils.isNearBottom @messages
    @messages.appendChild container
    Utils.scrollToBottom @messages if wasAtBottom

    @alert()

    return

  alert: ->
    @emit 'alertCountChanged', ++@alertCount
    return

  resetAlerts: ->
    @alertCount = -1
    @alert()

    return

module.exports = Page
