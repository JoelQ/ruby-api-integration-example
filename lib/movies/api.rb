require "sinatra/base"
require "securerandom"

class ThirdPartyApi < Sinatra::Base
  CLIENT_ID = "id"
  CLIENT_SECRET = "secret"

  # source: https://en.wikipedia.org/wiki/List_of_highest-grossing_films
  HIGHEST_GROSSING_FILMS = [
    { name: "Avatar", director: "James Cameron", gross: 2_847_246_203 },
    { name: "Avengers: Endgame", director: "Russo Bros", gross: 2_797_501_328 },
    { name: "Titanic", director: "James Cameraon", gross: 2_187_425_379 },
  ]

  def self.token
    @token
  end

  def self.generate_new_token
    @token = SecureRandom.hex
  end

  get "/movies" do
    if valid_token?
      HIGHEST_GROSSING_FILMS.to_json
    else
      status 401
    end
  end

  post "/new_token" do
    if params[:client_id] == CLIENT_ID && params[:client_secret] == CLIENT_SECRET
      self.class.generate_new_token
      self.class.token
    else
      status 422
    end
  end

  def valid_token?
    self.class.token && params[:token] == self.class.token && !expired_token?
  end

  # Token is expired approx 1/3 of the time
  def expired_token?
    [true, false, false].sample
  end

  # start the server if ruby file executed directly
  run! if app_file == $PROGRAM_NAME
end
