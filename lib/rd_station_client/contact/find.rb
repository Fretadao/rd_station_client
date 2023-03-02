# frozen_string_literal: true

module RDStationClient
  module Contact
    # Update a contact at RDStation based on this documentation: https://developers.rdstation.com/reference/get_platform-contacts-identifier-value
    #
    # Ex:
    #   RDStationClient::Contact::Find.(path_params: { identifier_type: 'email', identifier_value: 'contact@email.com' })
    #
    #   RDStationClient::Contact::Find.(path_params: { identifier_type: 'uuid', identifier_value: 'adf6d3d6-31da-41bd-8e5c-b3fbfbafa8a8' })
    #
    #   RDStationClient::Contact::Find.(email: 'contact@email.com')
    #
    #   RDStationClient::Contact::Find.(uuid: 'adf6d3d6-31da-41bd-8e5c-b3fbfbafa8a8')
    class Find < RDStationClient::Authenticated
      option :uuid, default: -> {}
      option :email, default: -> {}

      private

      def make_request
        self.class.get(formatted_path, headers: headers)
      end

      def path_template
        '/platform/contacts/%<identifier_type>s:%<identifier_value>s'
      end

      def path_params
        if email.present?
          { identifier_type: :email, identifier_value: email }
        elsif uuid.present?
          { identifier_type: :uuid, identifier_value: uuid }
        else
          super
        end
      end
    end
  end
end
