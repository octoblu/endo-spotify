http   = require 'http'
_      = require 'lodash'
Spotify = require '../../spotify-request'

class GetReccomendations
  constructor: ({@encrypted}) ->
    @spotify = new Spotify @encrypted.secrets.credentials.secret

  do: ({data}, callback) =>
    # return callback @_userError(422, 'data.username is required') unless data.username?
    { limit, market, offset, seed_artists, seed_genres, seed_tracks, min, max, target } = data

    max_filters = @_renameFilters 'max', max
    min_filters = @_renameFilters 'min', min
    target_filters = @_renameFilters 'target', target

    qs = {
      limit: limit
    }

    qs.offset = offset if offset?
    qs.market = market if market?
    qs.seed_artists = seed_artists || ""
    qs.seed_genres = seed_genres || ""
    qs.seed_tracks = seed_tracks || ""

    qs = _.merge qs, max_filters, min_filters, target_filters


    @spotify.request 'GET', "/v1/recommendations", qs, null, (error, response) =>
      return @_userError 422, error if error
      return callback null, {
        metadata:
          code: 200
          status: http.STATUS_CODES[200]
        data: response
      }

  _renameFilters: (prefix, filters) =>
    newFilters = {}
    _.forEach filters, (value, key) =>
      newFilters["#{prefix}_#{key}"] = value if value?
    return newFilters

  _userError: (code, message) =>
    error = new Error message
    error.code = code
    return error

module.exports = GetReccomendations
