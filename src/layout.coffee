EventEmitter = require './event_emitter'
Utils = require './utils'

class Layout extends EventEmitter
  constructor: ->
    @root = document.getElementById 'bows-root'
    @clearNode @root
    
    @createMessages()
    @createInput()

  clearNode: (node) ->
    while last_child = node.lastChild
      node.removeChild last_child
    return

  createMessages: ->
    @messages = document.createElement 'div'
    @messages.id = 'bows-messages'

    @root.appendChild @messages
    return

  createInput: ->
    @input = document.createElement 'textarea'
    @input.id = 'bows-input'
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

  addMessage: (serializedMessage) ->
    timeNode = document.createTextNode Utils.currentTimeString()
    textNode = document.createTextNode serializedMessage

    timeContainer = document.createElement 'span'
    timeContainer.className = 'bows-time'
    timeContainer.appendChild timeNode

    container = document.createElement 'p'
    container.className = 'bows-message'
    container.appendChild timeContainer
    container.appendChild Utils.nodeSeparator()
    container.appendChild textNode

    @messages.appendChild container
    @scrollToBottom @messages
    return

  scrollToBottom: (node) ->
    node.scrollTop = node.scrollHeight
    return

module.exports = Layout
