# frozen_string_literal: true

module TestRail
  module API
    module Sections
      def get_section(section_id)
        send_get("get_section/#{section_id}")
      end

      def get_sections(project_id, params = {})
        query = ''
        params.each do |key, value|
          query = "#{query}&#{key}=#{value}"
        end
        send_get("get_sections/#{project_id}#{query}")
      end

      def add_section(project_id, payload)
        send_post("add_section/#{project_id}", payload.compact)
      end

      def update_section(section_id, payload)
        send_post("update_section/#{section_id}", payload.compact)
      end

      def delete_section(section_id)
        send_post("delete_section/#{section_id}", nil)
      end

      def param_for_getting_sections
        {
          suite_id: nil
        }
      end

      def payload_for_adding_section
        {
            description: nil,
            suite_id: nil,
            parent_id: nil,
            name: nil
        }
      end

      def payload_for_updating_section
        {
            description: nil,
            name: nil
        }
      end
    end
  end
end
