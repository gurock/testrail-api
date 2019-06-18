# frozen_string_literal: true

module TestRail
  module API
    module ResultFields
      def get_result_fields
        send_get('get_result_fields')
      end
    end
  end
end
