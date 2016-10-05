_ = require 'lodash'
PassportSpotify = require('passport-spotify').Strategy

class SpotifyStrategy extends PassportSpotify
  constructor: (env) ->
    throw new Error('Missing required environment variable: ENDO_SPOTIFY_SPOTIFY_CLIENT_ID')     if _.isEmpty process.env.ENDO_SPOTIFY_SPOTIFY_CLIENT_ID
    throw new Error('Missing required environment variable: ENDO_SPOTIFY_SPOTIFY_CLIENT_SECRET') if _.isEmpty process.env.ENDO_SPOTIFY_SPOTIFY_CLIENT_SECRET
    throw new Error('Missing required environment variable: ENDO_SPOTIFY_SPOTIFY_CALLBACK_URL')  if _.isEmpty process.env.ENDO_SPOTIFY_SPOTIFY_CALLBACK_URL

    options = {
      clientID:     process.env.ENDO_SPOTIFY_SPOTIFY_CLIENT_ID
      clientSecret: process.env.ENDO_SPOTIFY_SPOTIFY_CLIENT_SECRET
      callbackURL:  process.env.ENDO_SPOTIFY_SPOTIFY_CALLBACK_URL
    }

    super options, @onAuthorization

  onAuthorization: (accessToken, refreshToken, profile, callback) =>
    callback null, {
      id: profile.id
      username: profile.username
      secrets:
        credentials:
          secret: accessToken
          refreshToken: refreshToken
    }

module.exports = SpotifyStrategy
