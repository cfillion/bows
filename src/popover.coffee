Spinner = require 'spin.js'
Utils = require './utils'

class PopOver
  constructor: (@parent, title, @oninit) ->
    @node = Utils.createNode 'div', ['popover', 'hidden']
    @parent.appendChild @node

    @parent.onmouseenter = => @show()
    @parent.onmouseleave = => @hide()

    @title = Utils.createNode 'div', ['title', 'hidden']
    @setTitle title if title
    @node.appendChild @title

    @contents = Utils.createNode 'div', ['contents', 'hidden']
    @node.appendChild @contents

    [@width, @height] = [250, 80]

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
    Utils.show @title
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

  setTitle: (text) ->
    Utils.clearNode @title
    @title.appendChild document.createTextNode(text)
    return

  updateGeometry: ->
    parentRect = @parent.getBoundingClientRect()

    [width, height] = @scale @width, @height
    [top, left] = [parentRect.top, parentRect.left]
    height += @title.offsetHeight

    totalHeight = @node.offsetHeight
    # workaround a weird bug where the browsers ignore the titlebar's height
    # when the popover is displayed for the first time (FF & WebKit)
    totalHeight += @title.offsetHeight if totalHeight < height

    # align to the parent's center
    left = Math.max 5, left - (width / 2) + (parentRect.width / 2)

    if top - totalHeight < 0
      Utils.removeClass 'above', @node
      Utils.addClass 'below', @node
      top += parentRect.height
    else
      Utils.removeClass 'below', @node
      Utils.addClass 'above', @node
      top -= totalHeight

    widthOverflow = (left + width) - Utils.windowWidth()
    widthOverflow += 45 # minimum margin
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
