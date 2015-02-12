EventEmitter = require './event_emitter'
Utils = require './utils'
hash = require 'string-hash'

MSG_COLOR_COUNT = 36

class Layout extends EventEmitter
  constructor: ->
    @root = document.getElementById 'bows-root'
    @clearNode @root
    
    @createTabbar()
    @createMessages()
    @createInput()

  clearNode: (node) ->
    while last_child = node.lastChild
      node.removeChild last_child
    return

  createTabbar: ->
    @tabbar = document.createElement 'div'
    @tabbar.className = 'bows-tabbar'

    tab = document.createElement 'span'
    tab.className = 'bows-tab-button bows-active'
    tab.appendChild document.createTextNode('Hello World')

    close = document.createElement 'span'
    close.className = 'bows-close'
    close.appendChild document.createTextNode("\u00D7")
    tab.appendChild Utils.nodeSeparator()
    tab.appendChild close

    @tabbar.appendChild tab

    tab2 = document.createElement 'span'
    tab2.appendChild document.createTextNode('LuCiE')
    tab2.className = 'bows-tab-button'
    @tabbar.appendChild tab2

    tab3 = document.createElement 'span'
    tab3.className = 'bows-tab-button'
    tab3.appendChild document.createTextNode('news')
    @tabbar.appendChild tab3

    @root.appendChild @tabbar
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
