# frozen_string_literal: true

module RDStationClient
  class Configuration < FHTTPClient::Configuration
    setting :rd_client_id
    setting :rd_secret
    setting :rd_code
    setting :redis do
      setting :pool_size, default: 5
      setting :connection_params, default: {}
    end
  end
end
