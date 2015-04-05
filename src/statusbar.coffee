Utils = require './utils'

class StatusBar
  constructor: ->
    @node = Utils.createNode 'div', 'statusbar'

    @suffixStep = 1
    @ongoingSuffixes = []
    @suffixTimer = setInterval (=> @updateSuffixes()), 1000

  setStatus: (callback) ->
    @reset()
    callback.bind(this)()

  reset: ->
    @ongoingSuffixes.length = 0
    Utils.clearNode @node
    return
  
  addError: (message) ->
    @addMessage message, 'error'

  addOngoing: (message) ->
    textNode = @addMessage message, 'ongoing'

    suffixNode = Utils.createNode 'span'
    @ongoingSuffixes.push suffixNode
    @node.insertBefore suffixNode, textNode.nextSibling

    @updateSuffixes false

    textNode

  addIndicator: (message) ->
    @addMessage message, 'indicator'

  addMessage: (message, klass) ->
    textNode = Utils.createNode 'span', klass
    textNode.appendChild document.createTextNode(message)

    @node.appendChild textNode
    @node.appendChild Utils.nodeSeparator()

    textNode

  updateSuffixes: (increment = true) ->
    for suffixNode in @ongoingSuffixes
      Utils.clearNode suffixNode

      @suffixStep++ if increment

      suffix = ''
      for step in [0...@suffixStep]
        switch step
          when 0 then continue
          when 3 then @suffixStep = 0

        suffix += "."

      suffixNode.appendChild document.createTextNode(suffix)

    return

module.exports = StatusBar
