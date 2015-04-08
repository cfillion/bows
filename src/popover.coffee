EventEmitter = require './event_emitter'

Spinner = require 'spin.js'
Utils = require './utils'

class PopOver extends EventEmitter
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

  fail: ->
    @clear()

    message = 'The preview could not be loaded.'
    p1 = Utils.createNode 'p'
    p1.appendChild document.createTextNode(message)
    @appendChild p1

    btn = Utils.createNode 'span', 'btn-active'
    btn.appendChild document.createTextNode('Open in a new tab')
    p2 = Utils.createNode 'p'
    p2.appendChild btn
    @appendChild p2

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
    # reset custom styles since we may not overwrite everything
    @node.removeAttribute 'style'

    parentRect = @parent.getBoundingClientRect()
    padding = parseInt(Utils.cssValue 'padding-left', @contents) || 0

    [width, height] = @scale @width, @height
    @emit 'scaled', width, height
    height += @title.offsetHeight + padding
    width += (padding * 2)

    @node.style.width = "#{width}px"
    @node.style.height = "#{height}px"

    if parentRect.top - @node.offsetHeight < 0
      Utils.removeClass 'above', @node
      Utils.addClass 'below', @node
      @node.style.top = "#{parentRect.top + parentRect.height}px"
    else
      Utils.removeClass 'below', @node
      Utils.addClass 'above', @node
      @node.style.bottom = "#{Utils.windowHeight() - parentRect.top}px"

    # align to the parent's center
    left = Math.max 5, parentRect.left - (width / 2) + (parentRect.width / 2)

    leftOverflow = (left + width) - Utils.windowWidth()
    leftOverflow += 45 # minimum margin
    left -= leftOverflow if leftOverflow > 0

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
