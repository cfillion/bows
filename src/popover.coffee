Spinner = require 'spin.js'
Utils = require './utils'

class PopOver
  constructor: (@parent, @oninit) ->
    @node = Utils.createNode 'div', ['popover', 'hidden']
    @parent.appendChild @node

    @parent.onmouseenter = => @show()
    @parent.onmouseleave = => @hide()

    @body = Utils.createNode 'div', 'body'
    @node.appendChild @body

    @contents = Utils.createNode 'div', 'hidden'
    @body.appendChild @contents

    [@width, @height] = [250, 50]

    # wait until the browser knows what the node's color should be
    window.setTimeout =>
      @spinner = new Spinner
        color: Utils.cssValue 'color', @body
      @spinner.spin @body
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
    left = rect.left
    top = rect.top - @body.offsetHeight

    @body.style.width = "#{width}px"
    @body.style.height = "#{height}px"
    @node.style.top = "#{top}px"
    @node.style.left = "#{left}px"

    return

  scale: (width, height) ->
    halfWidth = document.body.clientWidth / 1.5
    halfHeight = document.body.clientHeight / 1.5

    if width > halfWidth
      height /= width / halfWidth
      width = halfWidth

    if height > halfHeight
      width /= height / halfHeight
      height = halfHeight

    [width, height]

module.exports = PopOver
