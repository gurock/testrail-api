# frozen_string_literal: true

module TestRail
  module API
    module Runs
      def get_run(run_id)
        send_get("get_run/#{run_id}")
      end

      def get_run_payload(
          name = nil, description = nil, suite_id = nil,
          milestone_id = nil, assignedto_id = nil, include_all = nil, case_ids = nil)
        {
          name: name,
          description: description,
          suite_id: suite_id,
          milestone_id: milestone_id,
          assignedto_id: assignedto_id,
          include_all: include_all,
          case_ids: case_ids
        }
      end

      def add_run(payload)
        send_post("add_run/#{@project_id}", payload.compact)
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
