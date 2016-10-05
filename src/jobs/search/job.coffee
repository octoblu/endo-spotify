http   = require 'http'
_      = require 'lodash'
Spotify = require '../../spotify-request'

class Search
  constructor: ({@encrypted}) ->
    @spotify = new Spotify @encrypted.secrets.credentials.secret

  do: ({data}, callback) =>
    return callback @_userError(422, 'data.q is required') unless data.q?
    { q, type, limit, offset } = data

    qs = {
      q: q
      type: type
      limit: limit
    }

    qs.offset = offset if offset?

    @spotify.request 'GET', "/v1/search", qs, null, (error, response) =>
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

module.exports = Search
