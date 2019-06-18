# frozen_string_literal: true

module TestRail
  module API
    module Reports
      def get_reports(project_id)
        send_get("get_reports/#{project_id}")
      end

      def run_reports(report_template_id)
        send_get("run_reports/#{report_template_id}")
      end
    end
  end
end
