# frozen_string_literal: true

module TestRail
  module API
    module Template
      def get_templates(project_id)
        send_get("get_templates/#{project_id}")
      end
    end
  end
end
