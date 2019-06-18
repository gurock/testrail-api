# frozen_string_literal: true

module TestRail
  module API
    module Projects
      def get_project(project_id)
        send_get("get_project/#{project_id}")
      end

      def get_projects
        send_get('get_projects')
      end

      def add_project(payload)
        send_post('add_project', payload)
      end

      def update_project(project_id, is_completed)
        send_post("update_project/#{project_id}", is_completed: is_completed)
      end

      def delete_project(project_id)
        send_post("delete_project/#{project_id}", nil)
      end

      def payload_for_adding_project
        {
          name: nil,
          announcement: nil,
          show_announcement: nil,
          suite_mode: nil
        }
      end
    end
  end
end
