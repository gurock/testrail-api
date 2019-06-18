# frozen_string_literal: true

module TestRail
  module API
    module Suites
      def get_suite(suite_id)
        send_get("get_suite/#{suite_id}")
      end

      def get_suites(project_id)
        send_get("get_suites/#{project_id}")
      end

      def add_suite(project_id, payload)
        send_post("add_suite/#{project_id}", payload.compact)
      end

      def update_suite(suite_id, payload)
        send_post("update_suite/#{suite_id}", payload.compact)
      end

      def delete_suite(suite_id)
        send_post("delete_suite/#{suite_id}", nil)
      end

      def payload_for_adding_suite
        {
          name: nil,
          description: nil
        }
      end
    end
  end
end
