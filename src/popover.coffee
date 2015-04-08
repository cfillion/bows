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

    [@width, @height] = [250, 50]

    # wait until the browser knows what the node's color should be
    window.setTimeout =>
      @spinner = new Spinner
        color: Utils.cssValue 'color', @node
      @spinner.spin @node
    , 0

    window.addEventListener 'resize', => @updateGeometry()
    @updateGeometry()

  resize: (@width, @height) ->
    @updateGeometry()
    return

  appendChild: (node) ->
    @contents.appendChild node
    return

  show: ->
    Utils.show @node

    if @oninit
      @oninit.bind(this)()
      delete @oninit

    @updateGeometry()
    return

  hide: ->
    Utils.hide @node
    return

  ready: ->
    Utils.show @contents
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

    [width, height] = @scale @width, @height
    [top, left] = [rect.top, rect.left]

    if top - height < 0
      Utils.addClass 'below', @node
      top += rect.height
    else
      Utils.addClass 'above', @node
      top -= @node.offsetHeight

    widthOverflow = (left + width) - Utils.windowWidth()
    widthOverflow += 15 # minimum margin
    left -= widthOverflow if widthOverflow > 0

    @node.style.width = "#{width}px"
    @node.style.height = "#{height}px"
    @node.style.top = "#{top}px"
    @node.style.left = "#{left}px"

    return

  scale: (width, height) ->
    halfWidth = Utils.windowWidth() / 1.5
    halfHeight = Utils.windowHeight() / 2

    if width > halfWidth
      height /= width / halfWidth
      width = halfWidth

    if height > halfHeight
      width /= height / halfHeight
      height = halfHeight

    [width, height]

module.exports = PopOver
