# frozen_string_literal: true

module TestRail
  module API
    module Configurations
      def get_configs(project_id)
        send_get("get_configs/#{project_id}")
      end

      def add_config_group(project_id)
        send_get("add_config_group/#{project_id}")
      end

      def add_config(config_group_id, payload)
        send_post("add_config/#{config_group_id}", payload.compact)
      end

      def update_config_group(config_group_id, payload)
        send_post("update_config_group/#{config_group_id}", payload.compact)
      end

      def update_config(config_id, payload)
        send_post("update_config/#{config_id}", payload.compact)
      end

      def delete_config_group(config_group_id)
        send_post("delete_config_group/#{config_group_id}", nil)
      end

      def delete_config(config_id)
        send_post("delete_config/#{config_id}", nil)
      end

      def payload_for_adding_config_group
        {
            name: nil
        }
      end

      def payload_for_adding_config
        {
          name: nil
        }
      end

      def payload_for_updating_config_group
        {
            name: nil
        }
      end

      def payload_for_updating_config
        {
            name: nil
        }
      end
    end
  end
end
