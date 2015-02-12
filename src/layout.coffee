EventEmitter = require './event_emitter'

Utils = require './utils'
TabBar = require './tabbar'

hash = require 'string-hash'

MSG_COLOR_COUNT = 36

class Layout extends EventEmitter
  constructor: ->
    @root = document.getElementById 'bows-root'
    @clearNode @root

    @tabbar = new TabBar
    @root.appendChild @tabbar.node

    @tabbar.addTab 'Hello World'
    @tabbar.addTab 'LuCiE'
    @tabbar.addTab 'news'
    @tabbar.setCurrentTab 0
    
    @createMessages()
    @createInput()

  clearNode: (node) ->
    while last_child = node.lastChild
      node.removeChild last_child
    return

  createMessages: ->
    @messages = document.createElement 'div'
    @messages.className = 'bows-messages'

    @root.appendChild @messages
    return

  createInput: ->
    @input = document.createElement 'textarea'
    @input.className = 'bows-input'
    @input.placeholder = 'Type your message here...'
    @input.onkeypress = (event) => @handleInput event.keyCode

    @root.appendChild @input
    return

  handleInput: (keyCode) ->
    switch keyCode
      when 13
        @emit 'input', @input.value
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

module.exports = Layout
