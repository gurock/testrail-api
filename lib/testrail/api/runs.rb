# frozen_string_literal: true

module TestRail
  module API
    module Runs
      def get_run(run_id)
        send_get("get_run/#{run_id}")
      end

      def get_runs(project_id)
        send_get("get_runs/#{project_id}")
      end

      def add_run(project_id, payload)
        send_post("add_run/#{project_id}", payload.compact)
      end

      def update_run(run_id)
        send_post("update_run/#{run_id}", payload.compact)
      end

      def close_run(run_id)
        send_post("close_run/#{run_id}", nil)
      end

      def delete_run(run_id)
        send_post("delete_run/#{run_id}", nil)
      end

      def payload_for_adding_run
        {
          name: nil,
          description: nil,
          suite_id: nil,
          milestone_id: nil,
          assignedto_id: nil,
          include_all: nil,
          case_ids: nil
        }
      end
    end
  end
end
