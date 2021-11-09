require "httparty"

module Consumer
  Movie = Struct.new(:name, :director, :gross, keyword_init: true)
  Director = Struct.new(:name, :movies, keyword_init: true)

  class Client
    DOMAIN = "http://localhost:4567"

    def initialize(client_id:, client_secret:)
      @client_id = client_id
      @client_secret = client_secret
    end

    def fetch_movies
      response = get_with_retry("movies")

      json = JSON.parse(response.body)
      json.map do |record|
        Movie.new(
          name: record.fetch("name"),
          director: record.fetch("director"),
          gross: record.fetch("gross"),
        )
      end
    end

    def fetch_directors
      response = get_with_retry("directors")

      json = JSON.parse(response.body)
      json.map do |record|
        Director.new(
          name: record.fetch("name"),
          movies: record.fetch("movies"),
        )
      end
    end

    private

    def get_with_retry(path)
      response = HTTParty.get("#{DOMAIN}/#{path}?token=#{@token}")

      if response.code == 401
        refresh_token
        HTTParty.get("#{DOMAIN}/#{path}?token=#{@token}")
      else
        response
      end
    end

    def refresh_token
      response = HTTParty.post(
        "#{DOMAIN}/new_token",
        body: {client_id: @client_id, client_secret: @client_secret}.to_json
      )

      @token = response.body
    end
  end
end
