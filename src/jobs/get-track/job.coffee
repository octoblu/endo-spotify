http   = require 'http'
_      = require 'lodash'
Spotify = require '../../spotify-request'

class GetTrack
  constructor: ({@encrypted}) ->
    @spotify = new Spotify @encrypted.secrets.credentials.secret

  do: ({data}, callback) =>
    return callback @_userError(422, 'data.id is required') unless data.id?

    @spotify.request 'method', "/v1/tracks/#{id}", null, null, (error, response) =>
      return @_userError 422, error if error
      return callback null, {
        metadata:
          code: 200
          status: http.STATUS_CODES[200]
        data: response
      }

  _userError: (code, message) =>
    error = new Error message
    error.code = code
    return error

module.exports = GetTrack
