EventEmitter = require './event_emitter'

Utils = require './utils'

hash = require 'string-hash'

MSG_COLOR_COUNT = 36

class Page extends EventEmitter
  constructor: (identifier) ->
    @node = document.createElement 'div'
    @node.className = 'bows-page'

    @messages = document.createElement 'div'
    @messages.className = 'bows-messages'
    @node.appendChild @messages

    @input = document.createElement 'textarea'
    @input.className = 'bows-input'
    @input.placeholder = 'Type your message here...'
    @input.onkeypress = (event) => @handleInput event.keyCode
    @node.appendChild @input

    @identifier = identifier
    @setName identifier

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

    timeContainer = document.createElement 'span'
    timeContainer.className = 'bows-time'
    timeContainer.appendChild timeNode

    nickContainer = document.createElement 'span'
    nickContainer.className = 'bows-nick'
    nickContainer.appendChild nickNode

    textContainer = document.createElement 'span'
    textContainer.className = 'bows-text'
    textContainer.appendChild textNode

    container = document.createElement 'p'
    container.className = "bows-message bows-color#{colorId + 1}"
    container.appendChild timeContainer

    container.appendChild Utils.nodeSeparator()
    container.appendChild nickContainer
    container.appendChild nickSuffix
    container.appendChild Utils.nodeSeparator()

    container.appendChild textContainer

    @messages.appendChild container
    @scrollToBottom @messages
    return

  scrollToBottom: (node) ->
    node.scrollTop = node.scrollHeight
    return

module.exports = Page
