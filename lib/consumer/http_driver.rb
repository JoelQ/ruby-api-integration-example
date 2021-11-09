require "httparty"

module Consumer
  class HttpDriver
    DOMAIN = "http://localhost:4567"

    def initialize(client_id:, client_secret:, token:)
      @token = token
      @client_id = client_id
      @client_secret = client_secret
    end

    def fetch(endpoint)
      response = HTTParty.get(build_uri(endpoint))

      if response.code == 401
        refresh_token
        HTTParty.get(build_uri(endpoint)).body
      else
        response.body
      end
    end

    private

    def build_uri(endpoint)
      "#{DOMAIN}/#{endpoint}?token=#{@token}"
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
