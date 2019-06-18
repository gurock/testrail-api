# frozen_string_literal: true

module TestRail
  module API
    module Priorities
      def get_priorities
        send_get('get_priorities')
      end
    end
  end
end
