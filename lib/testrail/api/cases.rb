# frozen_string_literal: true

module TestRail
  module API
    module Cases
      def get_case(case_id)
        send_get("get_case/#{case_id}")
      end

      def get_cases(project_id, params = {})
        query = ''
        params.each do |key, value|
          query = "#{query}&#{key}=#{value}"
        end
        send_get("get_cases/#{project_id}#{query}")
      end

      def add_case(section_id, payload)
        send_post("add_case/#{section_id}", payload.compact)
      end

      def update_case(case_id, payload)
        send_post("update_case/#{case_id}", payload.compact)
      end

      def delete_case(case_id)
        send_post("delete_case/#{case_id}", nil)
      end

      def params_for_getting_cases
        {
          project_id: nil,
          suite_id: nil,
          section_id: nil,
          limit: nil,
          offset: nil,
          filter: nil
        }
      end

      def payload_for_adding_case
        {
            title: nil,
            template_id: nil,
            type_id: nil,
            priority_id: nil,
            estimate: nil,
            milestone_id: nil,
            refs: nil
        }
      end

      def payload_for_updating_case
        payload_for_adding_case
      end
    end
  end
end
