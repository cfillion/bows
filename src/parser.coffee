Utils = require './utils'

TEXT = 0
STRONG = 1
ITALIC = 2
STRIKE = 3

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

  parseMarkdown: (string) ->
    nodes = []

    while string.length > 0
      if match = /(\*\*|__)(?=\S)(.*?\S[*_]*)\1/.exec string
        type = STRONG
        node = Utils.createNode 'strong'
      else if match = /(\*|_)(?=\S)(.*?\S)\1/.exec string
        type = ITALIC
        node = Utils.createNode 'em'
      else if match = /(~~)(?=\S)(.*?\S)\1/.exec string
        type = STRIKE
        node = Utils.createNode 's'
      else
        type = TEXT
        node = document.createTextNode string
        nodes.push node
        return nodes

      if match.index > 0
        prefix = string.substring 0, match.index
        nodes = nodes.concat @parseMarkdown(prefix)

      switch type
        when STRONG, ITALIC, STRIKE
          node.appendChild n for n in @parseMarkdown(match[2])
          nodes.push node

      nodes.push node
      string = string.substr match.index + match[0].length, match[0].length

    nodes

module.exports = StringParser
