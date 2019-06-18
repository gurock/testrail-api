# frozen_string_literal: true

module TestRail
  module API
    module CaseTypes
      def get_case_types
        send_get('get_case_types')
      end
    end
  end
end
