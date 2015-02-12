Utils = require './utils'

CLASS_TABBAR = 'bows-tabbar'
CLASS_TABBUTTON = 'bows-tab-button'
CLASS_CURRENT = 'bows-current'

class TabBar
  constructor: ->
    @node = document.createElement 'div'
    @node.className = 'bows-tabbar'

    @buttons = []
    @currentIndex = -1

  addTab: (name) ->
    index = @buttons.length

    btn = document.createElement 'span'
    btn.className = 'bows-tab-button'
    btn.appendChild document.createTextNode(name)
    btn.appendChild Utils.nodeSeparator()
    btn.appendChild Utils.closeButton()

    btn.onclick = => @setCurrentTab index

    @buttons.push btn
    @node.appendChild btn

    index
  
  setCurrentTab: (index) ->
    return unless btn = @buttons[index]

    if oldCurrent = @buttons[@currentIndex]
      Utils.removeClass 'bows-current', oldCurrent

    Utils.addClass CLASS_CURRENT, btn
    @currentIndex = index

    return


module.exports = TabBar
