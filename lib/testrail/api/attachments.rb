# frozen_string_literal: true

module TestRail
  module API
    module Attachments
      def add_attachment_to_result(result_id)
        send_post("add_attachment_to_result/#{result_id}")
      end

      def add_attachment_to_result_for_case(result_id, case_id)
        send_post("add_attachment_to_result_for_case/#{result_id}/#{case_id}", nil)
      end

      def get_attachments_for_case(case_id)
        send_get("get_attachments_for_case/#{case_id}")
      end

      def get_attachments_for_test(test_id)
        send_get("get_attachments_for_test/#{test_id}")
      end

      def get_attachment(attachment_id)
        send_get("get_attachment/#{attachment_id}")
      end

      def delete_attachment(attachment_id)
        send_post("delete_attachment/#{attachment_id}")
      end
    end
  end
end
