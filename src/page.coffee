EventEmitter = require './event_emitter'

History = require './history'
StringParser = require './parser'
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
    @input.onkeydown = (event) => @onInput event
    @input.onpaste = => @detectMultiline()

    @separator = Utils.createNode 'hr'

    @node.appendChild @input

    @identifier = identifier
    @setName identifier
    @isRoom = identifier[0] == '#'

    @alertCount = 0
    @hasFocus = false
    @multiline = false

    @history = new History
    @history.on 'changed', (newText) => @setInput newText

    window.addEventListener 'resize', => @onResize()

  setName: (newName) ->
    @name = newName
    @emit 'nameChanged', newName

    return

  onInput: (e) ->
    # wait until the character has been inserted into the textarea
    window.setTimeout (=> @detectMultiline()), 0

    hasModifier = e.altKey || e.ctrlKey || e.metaKey || e.shiftKey

    switch e.keyCode
      when 9 # tab
        ; # TODO: insert \t
      when 13 # return
        passThrough = if @multiline then !hasModifier else hasModifier
        return true if passThrough
        @sendInput()
      when 38, 40 # up and down arrows
        return true if @multiline && !hasModifier
        steps = e.keyCode - 39 # 38 -> -1, 40 -> 1
        @history.move steps, @input.value
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
    Utils.clearNode @alerts
    @addLine 'page cleared'
    return

  clearInput: ->
    @input.value = ''
    return

  sendInput: ->
    text = @input.value
    @history.push text

    @clearInput()
    @setMultiline false

    @emit 'input', text
    return

  setInput: (text) ->
    @input.value = text
    @detectMultiline()
    return

  restoreInput: (key = null) ->
    return unless @input.value.length == 0
    @history.restore key, @input.value
    return

  addMessage: (nick, text) ->
    prefix = document.createTextNode "#{nick}: "
    content = StringParser.parse text

    @addLine [prefix].concat(content), nick

  addAction: (nick, text) ->
    @addLine "* #{nick} #{text}", nick

  addLine: (content, group = 0) ->
    switch group
      when LINE_DEFAULT
        klass = 'color0'
      else
        colorId = hash(group) % MSG_COLOR_COUNT
        klass = "color#{colorId + 1}"

    timeNode = document.createTextNode Utils.currentTimeString()

    timeContainer = Utils.createNode 'span', 'time'
    timeContainer.appendChild timeNode

    textContainer = Utils.createNode 'span', 'text'

    if Utils.isString content
      textContainer.appendChild document.createTextNode(content)
    else if Utils.isArray content
      textContainer.appendChild node for node in content
    else
      textContainer.appendChild content

    container = Utils.createNode 'p', ['message', klass]
    container.appendChild timeContainer
    container.appendChild Utils.nodeSeparator()
    container.appendChild textContainer

    @restoreScrolling =>
      @messages.appendChild container
      Utils.truncateNode @messages

    @alert()

    return

  addError: (source, cause, context = 'local') ->
    source = Utils.truncate source, 64
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
    rejectButton.onclick = =>
      @alerts.removeChild alert
      @input.focus()

    alert.appendChild rejectButton

    @restoreScrolling =>
      @alerts.appendChild alert
      Utils.truncateNode @alerts, 5

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
    return

  detectMultiline: ->
    hasBreak = Utils.contains "\n", @input.value
    @setMultiline hasBreak if hasBreak != @multiline
    return

  setMultiline: (enable) ->
    if enable
      Utils.addClass 'multiline', @node
    else
      Utils.removeClass 'multiline', @node

    @multiline = enable
    return

module.exports = Page
