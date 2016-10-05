http   = require 'http'
_      = require 'lodash'
Spotify = require '../../spotify-request'

class GetUserPlaylist
  constructor: ({@encrypted}) ->
    @spotify = new Spotify @encrypted.secrets.credentials.secret

  do: ({data}, callback) =>
    return callback @_userError(422, 'data.user_id is required') unless data.user_id?

    { user_id, limit, offset } = data
    qs = {
      limit: limit
    }

    qs.offset = offset if offset?

    @spotify.request 'GET', "/v1/users/#{user_id}/playlists", qs, null, (error, response) =>
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

module.exports = GetUserPlaylist
