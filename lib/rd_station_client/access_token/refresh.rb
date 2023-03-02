# frozen_string_literal: true

module RDStationClient
  module AccessToken
    class Refresh < RDStationClient::Base
      option :refresh_token

      cache_strategy :null

      private

      def make_request
        self.class.post(formatted_path, headers: headers, body: body)
      end

      def path_template
        '/auth/token'
      end

      def body
        {
          client_id: config.rd_client_id,
          client_secret: config.rd_secret,
          refresh_token: refresh_token
        }.to_json
      end
    end
  end
end
