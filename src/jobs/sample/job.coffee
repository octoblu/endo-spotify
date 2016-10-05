http   = require 'http'
_      = require 'lodash'

class SampleTask
  constructor: ({@encrypted}) ->


  do: ({data}, callback) =>
    # return callback @_userError(422, 'data.username is required') unless data.username?
    return callback null, {
      metadata:
        code: 200
        status: http.STATUS_CODES[200]
      data: data.example
    }


  _userError: (code, message) =>
    error = new Error message
    error.code = code
    return error

module.exports = SampleTask
