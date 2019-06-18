# frozen_string_literal: true

module TestRail
  module API
    module Tests
      def get_test(test_id)
        send_get("get_test/#{test_id}")
      end

      def get_tests(run_id, params = {})
        query = ''
        params.each do |key, value|
          query = "#{query}&#{key}=#{value}"
        end
        send_get("get_tests/#{run_id}/#{query}")
      end

      def param_for_getting_tests
        {
            status_id: nil
        }
      end
    end
  end
end
