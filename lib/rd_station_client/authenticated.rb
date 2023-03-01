# frozen_string_literal: true

module RDStationClient
  class Authencitated < RDStationClient::Base
    AUTH_DATA_KEY = :auth_data

    def run
      ensure_access_token
        .and_then do
          super.on_failure(:unauthorized) do
            return refresh_access_token.and_then { super }
          end
        end
    end

    private

    def ensure_access_token
      return Success(:token_retrieved) if access_token.present?

      RDStationClient::AccessToken::Generate.()
        .and_then do |auth_data|
          store_auth_data(auth_data)
          Success(:token_generated)
        end
    end

    def refresh_access_token
      RDStationClient::AccessToken::Refresh.(refresh_token: refresh_token)
        .and_then do |auth_data|
          store_auth_data(auth_data)
          Success(:token_generated)
        end
    end

    def access_token
      auth_data[:access_token]
    end

    def refresh_token
      auth_data[:refresh_token]
    end

    def auth_data
      @auth_data ||= JSON.parse(storage.find(AUTH_DATA_KEY).presence || '{}', symbolize_names: true)
    end

    def store_auth_data(auth_data)
      storage.persist(AUTH_DATA_KEY, auth_data)
      @auth_data = auth_data

      nil
    end

    def storage
      @storage ||= RDStationClient::AccessToken::Storage.instance
    end

    def headers
      super.merge('Authorization' => "Bearer #{access_token}")
    end
  end
end
