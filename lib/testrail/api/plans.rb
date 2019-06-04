# frozen_string_literal: true

module TestRail
  module API
    module Plans
      def get_plan(plan_id)
        send_get("get_plan/#{plan_id}")
      end

      def add_plan(name = 'Test Plan. Created by API (Default)', description = '')
        send_post("add_plan/#{@project_id}", 'name': name, 'description': description)
      end

      def close_plan(plan_id)
        send_post("close_plan/#{plan_id}", nil)
      end

      def delete_plan(plan_id)
        send_post("delete_plan/#{plan_id}", nil)
      end
    end
  end
end
