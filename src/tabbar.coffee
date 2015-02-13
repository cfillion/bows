EventEmitter = require './event_emitter'

Utils = require './utils'

class TabBar extends EventEmitter
  constructor: ->
    @buttons = []
    @currentIndex = -1

    @node = document.createElement 'div'
    @node.className = 'bows-tabbar'

  addTab: (name) ->
    index = @buttons.length

    btn = document.createElement 'span'
    btn.className = 'bows-tab-button'

    btn.onclick = => @setCurrentTab index

    @buttons.push btn
    @node.appendChild btn

    @renameTab index, name

    index
  
  setCurrentTab: (index) ->
    return unless btn = @buttons[index]

    if oldCurrent = @buttons[@currentIndex]
      Utils.removeClass 'bows-current', oldCurrent

    Utils.addClass 'bows-current', btn

    @currentIndex = index
    @emit 'currentChanged', index

    return

  renameTab: (index, newName) ->
    return unless btn = @buttons[index]

    Utils.clearNode btn

    closeButton = Utils.closeButton()
    closeButton.onclick = => @closeTab index

    btn.appendChild document.createTextNode(newName)
    btn.appendChild Utils.nodeSeparator()
    btn.appendChild closeButton

    return

  closeTab: (index) ->
    alert "closing tab #{index}"


module.exports = TabBar
