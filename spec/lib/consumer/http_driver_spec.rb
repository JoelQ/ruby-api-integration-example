require "consumer/http_driver"

RSpec.describe Consumer::HttpDriver do
  describe "#fetch" do
    it "fetches the given data" do
      stub_request(:get, "#{Consumer::HttpDriver::DOMAIN}/movies?token=good").
        to_return(body: some_json)

      driver = Consumer::HttpDriver.new(token: "good")
      response = driver.fetch("movies")

      expect(response).to eq some_json
    end

    it "refreshes the access token and retries when it gets a 401" do
      stub_request(:get, "#{Consumer::HttpDriver::DOMAIN}/movies?token=bad").
        to_return(status: 401)

      stub_request(:post, "#{Consumer::HttpDriver::DOMAIN}/new_token")
        .with(body: {client_id: "id", client_secret: "secret"}.to_json)
        .to_return(body: "good")

      stub_request(:get, "#{Consumer::HttpDriver::DOMAIN}/movies?token=good").
        to_return(body: some_json)

      driver = Consumer::HttpDriver.new(client_id: "id", client_secret: "secret", token: "bad")
      response = driver.fetch("movies")

      expect(response).to eq some_json
    end
  end

  def some_json
    {some: "json"}.to_json
  end
end
