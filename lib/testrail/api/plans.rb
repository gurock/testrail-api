# frozen_string_literal: true

module TestRail
  module API
    module Plans
      def get_plan(plan_id)
        send_get("get_plan/#{plan_id}")
      end

      def get_plans(project_id)
        send_get("get_plans/#{project_id}")
      end

      def add_plan(project_id, payload)
        send_post("add_plan/#{project_id}", payload)
      end

      def close_plan(plan_id)
        send_post("close_plan/#{plan_id}", nil)
      end

      def delete_plan(plan_id)
        send_post("delete_plan/#{plan_id}", nil)
      end

      def payload_for_adding_plan
        {
          name: nil,
          description: nil,
          milestone_id: nil,
          entries: nil
        }
      end
    end
  end
end
