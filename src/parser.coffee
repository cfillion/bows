Utils = require './utils'

BOLDEXP = /(\*\*|__)(.*)\1/g

StringParser =
  parse: (string) ->
    truncateIndex = string.indexOf "\n"

    if truncateIndex != -1
      firstLine = Utils.truncate string, truncateIndex + 1
    else
      firstLine = string

    nodes = @parseMarkdown firstLine

    if truncateIndex != -1
      [button, oneLiner, codeblock] = @multilineNodes string
      oneLiner.appendChild node for node in nodes

      [button, Utils.nodeSeparator(), oneLiner, codeblock]
    else
      nodes

  parseMarkdown: (string) ->
    [document.createTextNode string]

  multilineNodes: (string) ->
    button = Utils.createNode 'span', 'expand'

    oneLiner = Utils.createNode 'span'

    codeblock = Utils.createNode 'pre', 'verbatim'
    codeblock.appendChild document.createTextNode(string)

    visible = null

    expand = ->
      visible = true
      Utils.clearNode button
      button.appendChild document.createTextNode('Collapse')

      Utils.hide oneLiner
      Utils.show codeblock

    collapse = ->
      visible = false
      Utils.clearNode button
      button.appendChild document.createTextNode('Read All')

      Utils.show oneLiner
      Utils.hide codeblock

    button.onclick = ->
      if visible then collapse() else expand()

    collapse()

    [button, oneLiner, codeblock]

module.exports = StringParser
