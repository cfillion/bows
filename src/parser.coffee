Utils = require './utils'

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
      if match = /\[([^\]]+?)\]\((\S+)(?: (["']?)([^\3]+)\3)?\)/.exec string
        # inline link tags
        node = Utils.createNode 'a'
        node.target = '_blank'
        node.href = match[2]
        node.title = match[4] if match[4]
        @deepParse match[1], node

      else if match = /((?:https?|ftp):\/\/(?:\S)+)/.exec string
        # automatic link
        node = Utils.createNode 'a'
        node.target = '_blank'
        node.href = match[1]
        node.appendChild document.createTextNode(node.href)

      else if match = /(\*\*|__)(?=\S)(.*?\S[*_]*)\1/.exec string
        # bold
        node = Utils.createNode 'strong'
        @deepParse match[2], node

      else if match = /(\*|_)(?=\S)(.*?\S)\1/.exec string
        # italic
        node = Utils.createNode 'em'
        @deepParse match[2], node

      else if match = /(~~)(?=\S)(.*?\S)\1/.exec string
        # strikethrough
        node = Utils.createNode 's'
        @deepParse match[2], node

      else
        # text
        node = document.createTextNode string
        nodes.push node
        return nodes

      # parses what comes before the matching string
      if match.index > 0
        prefix = string.substring 0, match.index
        nodes = nodes.concat @parseMarkdown(prefix)

      nodes.push node

      # removes the matched part of the string
      string = string.substr match.index + match[0].length, match[0].length

    nodes

  deepParse: (string, node) ->
    node.appendChild n for n in @parseMarkdown string
    return

module.exports = StringParser
