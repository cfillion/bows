ClientErrors =
  UNKNOWN_ERROR: 'unknown error'
  BROKEN_CLIENT: 'client is broken'
  COMMAND_NOT_FOUND: 'command not found'
  MISSING_ARGUMENTS: 'some arguments are missing'
  EXTRA_ARGUMENTS: 'too many arguments'
  SERIALIZATION_FAILED: 'contains illegal characters'
  PAGE_NOT_FOUND: 'page not found'
  PERMANENT_PAGE: 'permanent page'

ServerErrors = [
  ClientErrors.UNKNOWN_ERROR,
  ClientErrors.COMMAND_NOT_FOUND,
  'peer not found',
  'room not found',
  'foreign room',
  'you already joined this room',
  'invalid room name',
]

module.exports =
  client: ClientErrors
  server: ServerErrors
