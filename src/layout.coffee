EventEmitter = require './event_emitter'

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
    @input.placeholder = '[Input zone]'
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

  addMessage: (serializedMessage) ->
    text_node = document.createTextNode serializedMessage

    container = document.createElement 'p'
    container.appendChild text_node

    @messages.appendChild container
    @scrollToBottom @messages
    return

  scrollToBottom: (node) ->
    node.scrollTop = node.scrollHeight
    return

module.exports = Layout
