ClientErrors =
  MISSING_ARGUMENTS: 'some arguments are missing'
  EXTRA_ARGUMENTS: 'too many arguments'
  SERIALIZATION_FAILED: 'contains illegal characters'

ServerErrors = [
  'unknown error',
  'command not found',
  'peer not found',
  'room not found',
  'foreign room',
  'you already joined this room',
  'invalid room name',
]

module.exports =
  Client: ClientErrors
  Server: ServerErrors
