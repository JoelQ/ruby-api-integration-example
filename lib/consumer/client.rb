require "httparty"

module Consumer
  Movie = Struct.new(:name, :director, :gross, keyword_init: true)

  class Client
    DOMAIN = "http://localhost:4567"

    def fetch_movies
      response = HTTParty.get(DOMAIN + "/movies")
      json = JSON.parse(response.body)
      json.map do |record|
        Movie.new(
          name: record.fetch("name"),
          director: record.fetch("director"),
          gross: record.fetch("gross"),
        )
      end
    end
  end
end
