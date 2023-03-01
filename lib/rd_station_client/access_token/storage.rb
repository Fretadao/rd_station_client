# frozen_string_literal: true

require 'singleton'

require 'redis'
require 'connection_pool'
require 'forwardable'

module RDStationClient
  module AccessToken
    class Storage
      extend Forwardable
      include Singleton

      LIB_PREFIX = 'rd_station_client'

      delegate %i[with] => :@pool

      def initialize
        @pool = ::ConnectionPool.new(size: config.redis.pool_size) do
          Redis.new(config.redis.connection_params)
        end
      end

      def find(key)
        with { |connection| connection.get(key_path(key)) }
      end

      def persist(key, value)
        with { |connection| connection.set(key_path(key), value) }
      end

      private

      def config
        @config ||= RDStationClient::Configuration.config
      end

      def key_path(key)
        [LIB_PREFIX, key].join(':')
      end
    end
  end
end
