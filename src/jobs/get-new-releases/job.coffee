http   = require 'http'
_      = require 'lodash'
Spotify = require '../../spotify-request'

class GetNewReleases
  constructor: ({@encrypted}) ->
    @spotify = new Spotify @encrypted.secrets.credentials.secret

  do: ({data}, callback) =>
    { country, limit, offset } = data

    qs = {
      country: country
      limit: limit
    }

    qs.offset = offset if offset?

    @spotify.request 'GET', "/v1/browse/new-releases", null, null, (error, response) =>
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

module.exports = GetNewReleases
