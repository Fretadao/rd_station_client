# frozen_string_literal: true

module RDStationClient
  module Event
    module Conversion
      # Create an event at RDStation based on this documentation: https://developers.rdstation.com/reference/conversao?lng=pt-BR
      class Create < RDStationClient::Authenticated
        option :conversion_identifier
        option :email

        private

        def make_request
          self.class.post(formatted_path, headers: headers, body: body.to_json)
        end

        def path_template
          '/platform/conversions'
        end

        def body
          {
            event_type: 'CONVERSION',
            event_family: 'CDP',
            payload: {
              conversion_identifier: conversion_identifier,
              email: email
            }
          }
        end
      end
    end
  end
end
