# frozen_string_literal: true

module TestRail
  module API
    module Milestones
      def get_milestone(milestone_id)
        send_get("get_milestone/#{milestone_id}")
      end

      def get_milestones(project_id, params = {})
        query = ''
        params.each do |key, value|
          query = "#{query}&#{key}=#{value}"
        end
        send_get("get_milestones/#{project_id}/#{query}")
      end

      def add_milestone(project_id, payload)
        send_post("add_milestone/#{project_id}", payload.compact)
      end

      def update_milestone(milestone_id, payload)
        send_post("update_milestone/#{milestone_id}", payload.compact)
      end

      def delete_milestone(milestone_id, payload)
        send_post("delete_milestone/#{milestone_id}", payload.compact)
      end

      def param_for_getting_milestones
        {
            is_completed: nil,
            is_started: nil
        }
      end

      def payload_for_adding_milestone
        {
          name: nil,
          description: nil,
          due_on: nil,
          parent_id: nil,
          start_on: nil
        }
      end

      def payload_for_updating_milestone
        {
            is_completed: nil,
            is_started: nil,
            parent_id: nil,
            start_on: nil
        }
      end
    end
  end
end
