# Movies API

This is a sample API to be used to test building third-party integrations. It
allows fetching a list of popular movies, protected by a token-based
authentication system.

## Setting up

Download the repo and run `bundle install`. To run this server:

```
ruby lib/movies/api.rb
```

## API

It provides 3 endpoints:

### `POST /new_token`

Must must have `client_secret=secret` and `client_id=id` in the request body.
Returns a string token.

### `GET /movies`

Must pass a `token` parameter. Returns a JSON array of movies.

Tokens randomly expire. If making a request with a wrong or expired token, the
API returns a `401` status code. In that case you need to make a request to
`/new_token` to get a new token before re-trying to get the movies.

### `GET /directors`

Must pass a `token` parameter. Returns a JSON array of directors.

Tokens randomly expire. If making a request with a wrong or expired token, the
API returns a `401` status code. In that case you need to make a request to
`/new_token` to get a new token before re-trying to get the movies.
