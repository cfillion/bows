EventEmitter = require './event_emitter'

Utils = require './utils'

class TabBar extends EventEmitter
  constructor: ->
    @buttons = []
    @labels = []
    @alerts = []

    @currentIndex = -1

    @node = Utils.createNode 'div', 'tabbar'

  addTab: (name) ->
    index = @buttons.length

    closeButton = Utils.closeButton()
    closeButton.onclick = => @closeTab index

    label = Utils.createNode 'span', 'label'
    alert = Utils.createNode 'span', 'alert'

    btn = Utils.createNode 'span', 'tab-button'
    btn.appendChild label
    btn.appendChild Utils.nodeSeparator()
    btn.appendChild alert
    btn.appendChild Utils.nodeSeparator()
    btn.appendChild closeButton

    btn.onclick = => @setCurrentTab index

    @labels.push label
    @alerts.push alert
    @buttons.push btn

    @renameTab index, name

    @node.appendChild btn

    index
  
  setCurrentTab: (index) ->
    return unless btn = @buttons[index]

    if oldCurrent = @buttons[@currentIndex]
      Utils.removeClass 'current', oldCurrent

    Utils.addClass 'current', btn

    @currentIndex = index
    @emit 'currentChanged', index

    return

  renameTab: (index, newName) ->
    return unless label = @labels[index]

    Utils.clearNode label
    label.appendChild document.createTextNode(newName)

    return

  setAlertCount: (index, count) ->
    return unless alert = @alerts[index]

    Utils.clearNode alert
    alert.appendChild document.createTextNode(count) if count > 0

    return

  closeTab: (index) ->
    alert "closing tab #{index}"
    return

module.exports = TabBar
