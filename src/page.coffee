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
    @input.onkeypress = (event) => @handleInput event.keyCode

    @node.appendChild @input

    @identifier = identifier
    @setName identifier

    @alertCount = 0

  setName: (newName) ->
    @name = newName
    @emit 'nameChanged', newName

    return

  handleInput: (keyCode) ->
    switch keyCode
      when 13
        @emit 'input', @input.value
        @clearInput()
      else
        return true

    return false

  clearInput: ->
    @input.value = ''
    return

  addMessage: (command) ->
    time = Utils.currentTimeString()
    nick = command.argument 0
    text = command.argument 1

    colorId = hash(nick) % MSG_COLOR_COUNT

    timeNode = document.createTextNode time
    nickNode = document.createTextNode nick
    nickSuffix = document.createTextNode ':'
    textNode = document.createTextNode text

    timeContainer = Utils.createNode 'span', 'time'
    timeContainer.appendChild timeNode

    nickContainer = Utils.createNode 'span', 'nick'
    nickContainer.appendChild nickNode

    textContainer = Utils.createNode 'span', 'text'
    textContainer.appendChild textNode

    container = Utils.createNode 'p', ['message', "color#{colorId + 1}"]
    container.appendChild timeContainer

    container.appendChild Utils.nodeSeparator()
    container.appendChild nickContainer
    container.appendChild nickSuffix
    container.appendChild Utils.nodeSeparator()

    container.appendChild textContainer

    @messages.appendChild container
    @scrollToBottom @messages
    @alert()

    return

  scrollToBottom: (node) ->
    node.scrollTop = node.scrollHeight
    return

  alert: ->
    @emit 'alertCountChanged', ++@alertCount
    return

  resetAlerts: ->
    @alertCount = -1
    @alert()

    return

module.exports = Page
