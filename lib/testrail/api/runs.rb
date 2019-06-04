# frozen_string_literal: true

module TestRail
  module API
    module Runs
      def get_run(run_id)
        send_get("get_run/#{run_id}")
      end

      def get_default_payload(name = nil, description = nil)
        return {
          suite_id: nil,
          name: name,
          description: description,
          milestone_id: nil,
          assignedto_id: nil,
          include_all: nil,
          case_ids: nil
        }
      end

      def add_run(payload)
        send_post("add_run/#{@project_id}", payload)
      end

      def close_run(run_id)
        send_post("close_run/#{run_id}", nil)
      end

      def delete_run(run_id)
        send_post("delete_run/#{run_id}", nil)
      end
    end
  end
end
