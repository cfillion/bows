EventEmitter = require './event_emitter'

Utils = require './utils'

class TabBar extends EventEmitter
  constructor: ->
    @tabs = []
    @currentIndex = -1

    @node = Utils.createNode 'div', 'tabbar'

  addTab: (name) ->
    index = @tabs.length

    closeButton = Utils.closeButton()
    closeButton.onclick = => @closeTab index

    label = Utils.createNode 'span', 'label'
    alert = Utils.createNode 'span', 'alert'

    btn = Utils.createNode 'span', ['tab', 'new']
    btn.appendChild label
    btn.appendChild Utils.nodeSeparator()
    btn.appendChild alert
    btn.appendChild Utils.nodeSeparator()
    btn.appendChild closeButton

    btn.onclick = => @setCurrentTab index

    @tabs.push
      alert: alert
      button: btn
      closable: true
      label: label

    @renameTab index, name

    @node.appendChild btn

    index
  
  setCurrentTab: (index) ->
    return unless btn = @tabs[index].button

    if tab = @tabs[@currentIndex]
      Utils.removeClass 'current', tab.button

    Utils.addClass 'current', btn

    @currentIndex = index
    @emit 'currentChanged', index
    @markAsRead index

    return

  renameTab: (index, newName) ->
    return unless tab = @tabs[index]

    Utils.clearNode tab.label
    tab.label.appendChild document.createTextNode(newName)

    return

  setAlertCount: (index, count) ->
    return unless tab = @tabs[index]

    text = count.toLocaleString()

    Utils.clearNode tab.alert
    tab.alert.appendChild document.createTextNode(text) if count > 0

    return

  closeTab: (index) ->
    @emit 'closeRequested', index if @isClosable index
    return

  removeTab: (index) ->
    return unless tab = @tabs[index]

    @node.removeChild tab.button

    # don't change the other tab's indexes
    # the onclick callbacks would still use the old index

    @tabs[index] = false

  markAsRead: (index) ->
    return unless tab = @tabs[index]

    Utils.removeClass 'new', tab.button

  setClosable: (index, boolean) ->
    return unless tab = @tabs[index]

    tab.closable = boolean

    if boolean
      Utils.removeClass 'permanent', tab.button
    else
      Utils.addClass 'permanent', tab.button

  isClosable: (index) ->
    return unless tab = @tabs[index]
    tab.closable

module.exports = TabBar
