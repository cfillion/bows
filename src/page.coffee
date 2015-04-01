EventEmitter = require './event_emitter'

Utils = require './utils'

hash = require 'string-hash'

MSG_COLOR_COUNT = 36

LINE_DEFAULT = 0
PROMPT_ERROR = 0

class Page extends EventEmitter
  constructor: (identifier) ->
    @node = Utils.createNode 'div', 'page'

    @messages = Utils.createNode 'div', 'messages'
    @node.appendChild @messages

    @alerts = Utils.createNode 'div', 'alerts'
    @node.appendChild @alerts

    @input = Utils.createNode 'textarea', 'input'
    @input.placeholder = 'Type your message here...'
    @input.onkeypress = (event) => @onInput event.keyCode

    @separator = Utils.createNode 'hr'

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

    @hasFocus = true
    @resetAlerts()
    @input.focus()

    if @messages.lastChild == @separator
      @messages.removeChild @separator

    return

  blur: ->
    Utils.removeClass 'current', @node

    # move the separator to the bottom
    @messages.removeChild @separator if @messages.contains @separator
    @messages.appendChild @separator

    @hasFocus = false

    return

  clear: ->
    Utils.clearNode @messages
    Utils.clearNode @prompts
    @addLine 'page cleared'
    return

  clearInput: ->
    @input.value = ''
    return

  addMessage: (nick, text) ->
    @addLine "#{nick}: #{text}", nick

  addAction: (nick, text) ->
    @addLine "* #{nick} #{text}", nick

  addLine: (text, group = 0) ->
    switch group
      when LINE_DEFAULT
        klass = 'color0'
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

    @restoreScrolling =>
      @messages.appendChild container

    @alert()

    return

  addError: (source, cause, context = 'local') ->
    @addAlert PROMPT_ERROR, "#{source} → #{cause} (#{context})"

  addAlert: (type, message) ->
    titleString = null
    klass = null

    switch type
      when PROMPT_ERROR
        titleString = 'Error:'
        klass = 'error'

    alert = Utils.createNode 'div', 'alert'
    Utils.addClass klass, alert if klass

    if titleString
      title = Utils.createNode 'span', 'title'
      title.appendChild document.createTextNode(titleString)
      alert.appendChild title
      alert.appendChild Utils.nodeSeparator()

    alert.appendChild document.createTextNode(message)

    rejectButton = Utils.closeButton()
    rejectButton.onclick = => @alerts.removeChild alert
    alert.appendChild rejectButton

    @restoreScrolling =>
      @alerts.appendChild alert

    @alert()

    return

  alert: ->
    @emit 'alertCountChanged', ++@alertCount unless @hasFocus
    return

  resetAlerts: ->
    @emit 'alertCountChanged', @alertCount = 0
    return

  restoreScrolling: (callback) ->
    wasAtBottom = Utils.isNearBottom @messages
    callback()
    Utils.scrollToBottom @messages if wasAtBottom

module.exports = Page
