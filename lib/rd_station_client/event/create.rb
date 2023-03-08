# frozen_string_literal: true

module RDStationClient
  module Event
    # Create an event at RDStation based on this documentation: https://developers.rdstation.com/reference/eventos-padr%C3%A3o
    # Ex:
    #   RDStationClient::Event::Create.(
    #     body: {
    #       event_type: 'CONVERSION',
    #       event_family: 'CDP',
    #       payload: {
    #         conversion_identifier: 'Name of the conversion event',
    #         name: 'Nome',
    #         email: 'email@email.com',
    #         job_title: 'job title value',
    #         state: 'state of the contact',
    #         city: 'city of the contact',
    #         country: 'country of the contact',
    #         personal_phone: 'phone of the contact',
    #         mobile_phone: 'mobile_phone of the contact',
    #         twitter: 'twitter handler of the contact',
    #         facebook: 'facebook name of the contact',
    #         linkedin: 'linkedin user name of the contact',
    #         website: 'website of the contact',
    #         cf_custom_field_api_identifier: 'custom field value',
    #         company_name: 'company name',
    #         company_site: 'company website',
    #         company_address: 'company address',
    #         client_tracking_id: 'lead tracking client_id',
    #         traffic_source: 'Google',
    #         traffic_medium: 'cpc',
    #         traffic_campaign: 'easter-50-off',
    #         traffic_value: 'easter eggs',
    #         tags: [
    #           mql',
    #           2019'
    #         ],
    #         available_for_mailing: true,
    #         legal_bases: [
    #           {
    #             category: 'communications',
    #             type: 'consent',
    #             status: 'granted'
    #           }
    #         ]
    #       }
    #     }
    class Create < RDStationClient::Authenticated
      private

      def make_request
        self.class.post(formatted_path, headers: headers, body: body.to_json)
      end

      def path_template
        '/platform/events'
      end
    end
  end
end
