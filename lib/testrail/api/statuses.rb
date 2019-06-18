# frozen_string_literal: true

module TestRail
  module API
    module Statuses
      def get_statuses
        send_get('get_statuses')
      end
    end
  end
end
