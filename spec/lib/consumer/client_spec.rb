require "consumer/client"

RSpec.describe Consumer::Client do
  describe "#fetch_movies" do
    it "builds movies from the data returned by the driver" do
      driver = double(
        fetch: [
          {name: "Avatar", director: "James Cameron", gross: 12345},
          {name: "Titanic", director: "James Cameron", gross: 78910}
        ].to_json)

      client = Consumer::Client.new(driver: driver)
      movies = client.fetch_movies

      avatar = movies.first
      expect(avatar.name).to eq "Avatar"
      expect(avatar.gross).to eq 12345
      expect(avatar.director).to eq "James Cameron"
      expect(movies.length).to eq 2
    end
  end

  describe "#fetch_directors" do
    it "builds directors from data returned by the driver" do
      driver = double(fetch: [
        {name: "James Cameron", movies: ["Titanic", "Avatar"]},
        {name: "Russo Bros", movies: ["Avengers: Endgame"]},
      ].to_json)

      client = Consumer::Client.new(driver: driver)
      directors = client.fetch_directors

      cameron = directors.first
      expect(cameron.name).to eq "James Cameron"
      expect(cameron.movies).to eq ["Titanic", "Avatar"]
      expect(directors.length).to eq 2
    end
  end
end
