# frozen_string_literal: true

module TestRail
  module API
    module Results
      def get_results(test_id, params = {})
        query = ''
        params.each do |key, value|
          query = "#{query}&#{key}=#{value}"
        end
        send_get("get_results/#{test_id}#{query}")
      end

      def get_results_for_case(run_id, case_id, params = {})
        query = ''
        params.each do |key, value|
          query = "#{query}&#{key}=#{value}"
        end
        send_get("get_results_for_case/#{run_id}/#{case_id}#{query}")
      end

      def get_results_for_run(run_id, params = {})
        query = ''
        params.each do |key, value|
          query = "#{query}&#{key}=#{value}"
        end
        send_get("get_results_for_run/#{run_id}#{query}")
      end

      def add_result(test_id, payload)
        send_post("add_result/#{test_id}", payload.compact)
      end

      def add_result_for_case(run_id, case_id, payload)
        send_post("add_result_for_case/#{run_id}/#{case_id}", payload.compact)
      end

      def add_results(run_id, payload)
        send_post("add_results/#{run_id}", payload.compact)
      end

      def add_results_for_case(run_id, payload)
        send_post("add_results_for_case/#{run_id}", payload.compact)
      end

      def params_for_getting_results
        {
          limit: nil,
          offset: nil,
          status_id: nil
        }
      end

      def params_for_getting_result_for_case
        params_for_getting_results
      end

      def params_for_getting_results_for_run
        {
          created_after: nil,
          created_before: nil,
          created_by: nil,
          limit: nil,
          offset: nil,
          status_id: nil
        }
      end

      def payload_for_adding_result_for_case
        {
            status_id: nil,
            comment: nil,
            version: nil,
            elapsed: nil,
            defects: nil,
            assignedto_id: nil
        }
      end
    end
  end
end
