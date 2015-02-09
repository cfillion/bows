Utils =
  currentTimeString: ->
    date = new Date

    hours = @padLeft date.getHours(), '0', 2
    minutes = @padLeft date.getMinutes(), '0', 2
    seconds = @padLeft date.getSeconds(), '0', 2

    "#{hours}:#{minutes}:#{seconds}"

  padLeft: (input, pad, length) ->
    input = input.toString()

    while input.length < length
      input = pad + '' + input

    input

  nodeSeparator: ->
    document.createTextNode "\x20"

module.exports = Utils
