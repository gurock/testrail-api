# frozen_string_literal: true

RSpec.describe 'TestRail' do
  context 'API' do
    context 'Results' do
      before(:each) do
        @client = TestRail::Client.new(ENV['TESTRAIL_URL'])
      end

      it 'get default payload' do
        payload = @client.get_result_payload

        expect(payload[:status_id]).to be_nil
        expect(payload[:comment]).to be_nil
        expect(payload[:version]).to be_nil
        expect(payload[:elapsed]).to be_nil
        expect(payload[:defects]).to be_nil
        expect(payload[:assignedto_id]).to be_nil
        expect(payload[:unknown_parameter]).to be_nil

        status_id = 1
        comment = 'comment'
        version = 'version'
        elapsed = '30s'
        defects = 'defects'
        assignedto_id = 1

        payload = @client.get_result_payload(status_id, comment, version, elapsed, defects, assignedto_id)

        expect(payload[:status_id]).to eq(status_id)
        expect(payload[:comment]).to eq(comment)
        expect(payload[:version]).to eq(version)
        expect(payload[:elapsed]).to eq(elapsed)
        expect(payload[:defects]).to eq(defects)
        expect(payload[:assignedto_id]).to eq(assignedto_id)
        expect(payload[:unknown_parameter]).to be_nil
      end

      context 'result for case' do
        before(:each) do
          @case_id = '13539'
          @run = @client.add_run(@client.get_run_payload('Run Name', 'Run Description').compact)
        end

        it 'can add/get result for case' do
          status_id = 1
          comment = 'comment'
          version = nil
          elapsed = '30s'
          defects = 'defects'
          assignedto_id = 1

          payload = @client.get_result_payload(
            status_id, comment, version, elapsed, defects, assignedto_id
          )

          @client.add_result_for_case(@run['id'], @case_id, payload)
          results = @client.get_results_for_case(@run['id'], @case_id)

          expect(results[0]['status_id']).to eq(status_id)
          expect(results[0]['comment']).to eq(comment)
          expect(results[0]['version']).to be_nil
          expect(results[0]['elapsed']).to eq(elapsed)
          expect(results[0]['defects']).to eq(defects)
          expect(results[0]['assignedto_id']).to eq(assignedto_id)
        end

        after(:each) do
          @client.close_run(@run['id'])
        end
      end
    end
  end
end
