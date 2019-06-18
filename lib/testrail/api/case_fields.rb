# frozen_string_literal: true

module TestRail
  module API
    module CaseFields
      def get_case_fields
        send_get('get_case_fields')
      end

      def add_case_field(payload)
        send_get('add_case_field', payload.compact)
      end

      def payload_for_adding_case_field
        {
          type: nil,
          name: nil,
          label: nil,
          description: nil,
          include_all: nil,
          template_ids: nil,
          configs: nil
        }
      end
    end
  end
end
