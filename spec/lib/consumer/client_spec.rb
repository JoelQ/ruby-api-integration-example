require "consumer/client"

RSpec.describe Consumer::Client do
  describe "#fetch_movies" do
    it "fetches movies from the API" do
      stub_request(:get, "#{Consumer::Client::DOMAIN}/movies").
        to_return(body: [
          {name: "Avatar", director: "James Cameron", gross: 12345},
          {name: "Titanic", director: "James Cameron", gross: 78910}
        ].to_json)

      client = Consumer::Client.new
      movies = client.fetch_movies

      avatar = movies.first
      expect(avatar.name).to eq "Avatar"
      expect(avatar.gross).to eq 12345
      expect(avatar.director).to eq "James Cameron"
      expect(movies.length).to eq 2
    end
  end
end
