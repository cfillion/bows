EventEmitter = require './event_emitter'
Utils = require './utils'

class Layout extends EventEmitter
  constructor: ->
    @root = document.getElementById 'bows-root'
    @clear_node @root
    
    @create_messages()
    @create_input()

  clear_node: (node) ->
    while last_child = node.lastChild
      node.removeChild last_child
    return

  create_messages: ->
    @messages = document.createElement 'div'
    @messages.id = 'bows-messages'

    @root.appendChild @messages
    return

  create_input: ->
    @input = document.createElement 'textarea'
    @input.id = 'bows-input'
    @input.placeholder = 'Type your message here...'
    @input.onkeypress = (event) => @handle_input event.keyCode

    @root.appendChild @input
    return
  
  handle_input: (key_code) ->
    switch key_code
      when 13
        @emit 'send', @input.value
        @input.value = ''
      else
        return true

    return false

  addMessage: (serialized_message) ->
    time_node = document.createTextNode Utils.currentTimeString()
    text_node = document.createTextNode serialized_message

    time_container = document.createElement 'span'
    time_container.className = 'bows-time'
    time_container.appendChild time_node

    container = document.createElement 'p'
    container.className = 'bows-message'
    container.appendChild time_container
    container.appendChild Utils.nodeSeparator()
    container.appendChild text_node

    @messages.appendChild container
    @scrollToBottom @messages
    return

  scrollToBottom: (node) ->
    node.scrollTop = node.scrollHeight
    return

module.exports = Layout
