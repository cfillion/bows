Spinner = require 'spin.js'
Utils = require './utils'

class PopOver
  constructor: (@parent, @oninit) ->
    @node = Utils.createNode 'div', ['popover', 'hidden']
    @parent.appendChild @node

    @parent.onmouseenter = => @show()
    @parent.onmouseleave = => @hide()

    @contents = Utils.createNode 'div', 'hidden'
    @node.appendChild @contents

    # wait until the browser knows what the node's color should be
    window.setTimeout =>
      @spinner = new Spinner
        color: Utils.cssValue 'color', @node
      @spinner.spin @node
    , 0

  appendChild: (node) ->
    @contents.appendChild node
    return

  show: ->
    Utils.removeClass 'hidden', @node

    if @oninit
      @oninit.bind(this)()
      delete @oninit

    @updateGeometry()
    return

  hide: ->
    Utils.addClass 'hidden', @node
    return

  ready: ->
    Utils.removeClass 'hidden', @contents
    @spinner.stop()

    @updateGeometry()
    return

  fail: (message = null) ->
    @clear()

    message || (message = 'The preview could not be loaded.')
    p = Utils.createNode 'p'
    p.appendChild document.createTextNode(message)
    @appendChild p

    @ready()

    return

  clear: ->
    Utils.clearNode @contents
    return

  updateGeometry: ->
    rect = @parent.getBoundingClientRect()

    @node.style.left = "#{rect.left}px"
    @node.style.top = "#{rect.top - @node.offsetHeight}px"

    return

module.exports = PopOver
