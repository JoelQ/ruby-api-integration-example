require "consumer/client"

RSpec.describe Consumer::Client do
  describe "#fetch_movies" do
    it "fetches movies from the API" do
      stub_request(:get, "#{Consumer::Client::DOMAIN}/movies?token=").
        to_return(body: [
          {name: "Avatar", director: "James Cameron", gross: 12345},
          {name: "Titanic", director: "James Cameron", gross: 78910}
        ].to_json)

      client = Consumer::Client.new(client_id: "id", client_secret: "secret")
      movies = client.fetch_movies

      avatar = movies.first
      expect(avatar.name).to eq "Avatar"
      expect(avatar.gross).to eq 12345
      expect(avatar.director).to eq "James Cameron"
      expect(movies.length).to eq 2
    end

    it "refreshes token and retries request when given a 401" do
      stub_request(:get, "#{Consumer::Client::DOMAIN}/movies?token=").
        to_return(status: 401)

      stub_request(:post, "#{Consumer::Client::DOMAIN}/new_token")
        .with(body: {client_id: "id", client_secret: "secret"}.to_json)
        .to_return(body: "good")

      stub_request(:get, "#{Consumer::Client::DOMAIN}/movies?token=good").
        to_return(body: [
          {name: "Avatar", director: "James Cameron", gross: 12345},
          {name: "Titanic", director: "James Cameron", gross: 78910}
        ].to_json)

      client = Consumer::Client.new(client_id: "id", client_secret: "secret")
      movies = client.fetch_movies

      avatar = movies.first
      expect(avatar.name).to eq "Avatar"
      expect(avatar.gross).to eq 12345
      expect(avatar.director).to eq "James Cameron"
      expect(movies.length).to eq 2
    end
  end
end
