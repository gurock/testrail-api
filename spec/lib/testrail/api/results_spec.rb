# frozen_string_literal: true

RSpec.describe 'TestRail' do
  context 'API' do
    context 'Results' do
      before(:each) do
        @client = TestRail::Client.new
      end

      context 'result for case' do
        before(:each) do
          @project_id = RSpec.current_example.metadata[:project_id]
          @case_id = RSpec.current_example.metadata[:case_id]
          payload = @client.payload_for_adding_run
          payload[:name] = 'Run name created by rspec'
          @run = @client.add_run(@project_id, payload)
        end

        it 'can add/get result for case' do
          payload = @client.payload_for_adding_result_for_case
          payload[:status_id] = 1
          payload[:comment] = 'comment'
          payload[:version] = nil
          payload[:elapsed] = '30s'
          payload[:defects] = 'defects'
          payload[:assignedto_id] = 1

          @client.add_result_for_case(@run['id'], @case_id, payload)
          results = @client.get_results_for_case(@run['id'], @case_id)

          expect(results[0]['status_id']).to eq(payload[:status_id])
          expect(results[0]['comment']).to eq(payload[:comment])
          expect(results[0]['version']).to be_nil
          expect(results[0]['elapsed']).to eq(payload[:elapsed])
          expect(results[0]['defects']).to eq(payload[:defects])
          expect(results[0]['assignedto_id']).to eq(payload[:assignedto_id])
        end

        after(:each) do
          @client.close_run(@run['id'])
        end
      end

      it 'get default payload' do
        payload = @client.payload_for_adding_result_for_case

        expect(payload[:status_id]).to be_nil
        expect(payload[:comment]).to be_nil
        expect(payload[:version]).to be_nil
        expect(payload[:elapsed]).to be_nil
        expect(payload[:defects]).to be_nil
        expect(payload[:assignedto_id]).to be_nil
        expect(payload[:unknown_parameter]).to be_nil
      end
    end
  end
end
