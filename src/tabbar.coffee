EventEmitter = require './event_emitter'

Utils = require './utils'

class TabBar extends EventEmitter
  constructor: ->
    @buttons = []
    @labels = []
    @currentIndex = -1

    @node = Utils.createNode 'div', 'tabbar'

  addTab: (name) ->
    index = @buttons.length

    closeButton = Utils.closeButton()
    closeButton.onclick = => @closeTab index

    label = Utils.createNode 'span'

    btn = Utils.createNode 'span', 'tab-button'
    btn.appendChild label
    btn.appendChild Utils.nodeSeparator()
    btn.appendChild closeButton

    btn.onclick = => @setCurrentTab index

    @buttons.push btn
    @labels.push label
    @node.appendChild btn

    @renameTab index, name

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

  closeTab: (index) ->
    alert "closing tab #{index}"


module.exports = TabBar
