# frozen_string_literal: true

module RDStationClient
  module Contact
    # Update a contact at RDStation based on this documentation: https://developers.rdstation.com/reference/patch_platform-contacts-identifier-value
    # Ex:
    #   RDStationClient::Contact::Update.(
    #     path_params: { identifier_type: 'email', identifier_value: 'contact@email.com' },
    #     body: {
    #       name: 'John Doe',
    #       website: 'http://mysite.com',
    #       bio: 'My name is John Doe'
    #     }
    #   )
    class Update < RDStationClient::Authenticated
      private

      def make_request
        self.class.patch(formatted_path, headers: headers, body: body.to_json)
      end

      def path_template
        '/platform/contacts/%<identifier_type>s:%<identifier_value>s'
      end
    end
  end
end
