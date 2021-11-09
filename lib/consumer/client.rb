require "httparty"
require "consumer/http_driver"

module Consumer
  Movie = Struct.new(:name, :director, :gross, keyword_init: true)
  Director = Struct.new(:name, :movies, keyword_init: true)

  class Client
    def initialize(client_id:, client_secret:)
      @driver = HttpDriver.new(client_id: client_id, client_secret: client_secret, token: "")
    end

    def fetch_movies
      json = @driver.fetch("movies")

      data = JSON.parse(json)
      data.map do |record|
        Movie.new(
          name: record.fetch("name"),
          director: record.fetch("director"),
          gross: record.fetch("gross"),
        )
      end
    end

    def fetch_directors
      json = @driver.fetch("directors")

      data = JSON.parse(json)
      data.map do |record|
        Director.new(
          name: record.fetch("name"),
          movies: record.fetch("movies"),
        )
      end
    end
  end
end
