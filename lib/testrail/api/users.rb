# frozen_string_literal: true

module TestRail
  module API
    module Users
      def get_user(user_id)
        send_get("get_user/#{user_id}")
      end

      def get_user_by_email(params = {})
        query = ''
        params.each do |key, value|
          query = "#{query}&#{key}=#{value}"
        end
        send_get("get_user_by_email/#{run_id}/#{query}")
      end

      def get_users
        send_get('get_users')
      end

      def param_for_getting_user_by_email
        {
            email: nil
        }
      end
    end
  end
end
