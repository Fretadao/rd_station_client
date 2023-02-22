# frozen_string_literal: true

require 'f_http_client'
require_relative 'rd_station_client/version'
require 'rd_station_client/configuration'

module RDStationClient
  extend FHTTPClient

  def self.configuration_class
    'RDStationClient::Configuration'
  end
end
