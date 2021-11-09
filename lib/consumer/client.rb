require "httparty"

module Consumer
  Movie = Struct.new(:name, :director, :gross, keyword_init: true)

  class Client
    DOMAIN = "http://localhost:4567"

    def initialize(client_id:, client_secret:)
      @client_id = client_id
      @client_secret = client_secret
    end

    def fetch_movies
      response = HTTParty.get("#{DOMAIN}/movies?token=#{@token}")

      if response.code == 401
        refresh_token
        response = HTTParty.get("#{DOMAIN}/movies?token=#{@token}")
      end

      json = JSON.parse(response.body)
      json.map do |record|
        Movie.new(
          name: record.fetch("name"),
          director: record.fetch("director"),
          gross: record.fetch("gross"),
        )
      end
    end

    private

    def refresh_token
      response = HTTParty.post(
        "#{DOMAIN}/new_token",
        body: {client_id: @client_id, client_secret: @client_secret}.to_json
      )

      @token = response.body
    end
  end
end
