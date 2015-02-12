Controller = require './controller'

module.exports =
  setup: (config) ->
    new Controller config

    return
