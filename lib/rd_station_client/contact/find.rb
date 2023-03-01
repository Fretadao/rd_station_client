# frozen_string_literal: true

module RDStationClient
  module Contact
    # Update a contact at RDStation based on this documentation: https://developers.rdstation.com/reference/get_platform-contacts-identifier-value
    #
    # Ex:
    #   RDStationClient::Contact::Update.(
    #     path_params: { identifier_type: 'email', identifier_value: 'contact@email.com' }
    #   )
    class Find < RDStationClient::Authencitated
      private

      def make_request
        self.class.get(formatted_path, headers: headers)
      end

      def path_template
        '/platform/contacts/%<identifier_type>s:%<identifier_value>s'
      end
    end
  end
end
