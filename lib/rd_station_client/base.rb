# frozen_string_literal: true

module RDStationClient
  class Base < FHTTPClient::Base
    def self.config
      RDStationClient::Configuration.config
    end

    private

    def headers
      @headers.merge('Content-Type' => 'application/json')
    end
  end
end
