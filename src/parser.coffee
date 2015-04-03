Utils = require './utils'

MAXLENGTH = 200
BOLDEXP = /(\*\*|__)(.*)\1/g

truncatedNodes = (string) ->
  nodes = []

  button = Utils.createNode 'span', 'expand'

  codeblock = Utils.createNode 'pre', 'verbatim'
  codeblock.appendChild document.createTextNode(string)

  visible = null

  expand = ->
    visible = true
    Utils.clearNode button
    button.appendChild document.createTextNode('Collapse')

    Utils.show codeblock

  collapse = ->
    visible = false
    Utils.clearNode button
    button.appendChild document.createTextNode('Read All')

    Utils.hide codeblock

  button.onclick = ->
    if visible then collapse() else expand()

  nodes.push Utils.nodeSeparator()
  nodes.push button
  nodes.push codeblock

  collapse()

  nodes

StringParser =
  parse: (string) ->
    truncateIndex = string.indexOf "\n"
    oneLiner = string
    truncated = false

    if truncateIndex != -1
      truncateIndex = Math.min truncateIndex + 1, MAXLENGTH
    else
      truncateIndex = MAXLENGTH

    if string.length > truncateIndex
      oneLiner = Utils.truncate string, truncateIndex
      truncated = true

    nodes = []
    nodes.push document.createTextNode(oneLiner)

    if truncated
      nodes.concat truncatedNodes(string)
    else
      nodes

module.exports = StringParser
