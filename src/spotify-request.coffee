request = require 'request'

class SpotifyRequest
  constructor: (access_token) ->
    @base_uri = 'https://api.spotify.com'
    @access_token = access_token

  request: (method, path, qs, body, callback) =>
    options = {
      uri: @base_uri + path
      method: method
      json: true
      headers:
        Authorization: 'Bearer ' + @access_token
    }

    options.qs = qs if qs?
    options.body = body if body?

    request options, (error, res, body) =>
      callback error, body

module.exports = SpotifyRequest
