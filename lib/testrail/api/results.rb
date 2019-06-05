# frozen_string_literal: true

module TestRail
  module API
    module Results
      def get_results_for_case(run_id, case_id)
        send_get("get_results_for_case/#{run_id}/#{case_id}")
      end

      def add_result_for_case(run_id, case_id, payload)
        send_post("add_result_for_case/#{run_id}/#{case_id}", payload)
      end

      def get_result_payload(
          status_id = nil, comment = nil, version = nil,
          elapsed = nil, defects = nil, assignedto_id = nil)
        {
          status_id: status_id,
          comment: comment,
          version: version,
          elapsed: elapsed,
          defects: defects,
          assignedto_id: assignedto_id
        }
      end
    end
  end
end
