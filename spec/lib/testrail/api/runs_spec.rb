# frozen_string_literal: true

RSpec.describe 'TestRail' do
  context 'API' do
    context 'Runs' do
      before(:each) do
        @client = TestRail::Client.new(ENV['TESTRAIL_URL'])
        @name = 'Test Run Name'
        @description = 'Test Run Description'
      end

      it 'get default payload' do
        payload = @client.get_default_payload

        expect(payload[:suite_id]).to be_nil
        expect(payload[:name]).to be_nil
        expect(payload[:description]).to be_nil
        expect(payload[:milestone_id]).to be_nil
        expect(payload[:assignedto_id]).to be_nil
        expect(payload[:include_all]).to be_nil
        expect(payload[:case_ids]).to be_nil
        expect(payload[:unknown_parameter]).to be_nil
      end

      it 'get default payload with name and description' do
        payload = @client.get_default_payload(@name, @description)

        expect(payload[:name]).to eq(@name)
        expect(payload[:description]).to eq(@description)
      end

      it 'can add/get/delete test run ' do
        payload = @client.get_default_payload(@name, @description)

        run = @client.add_run(payload.compact)
        run = @client.get_run(run['id'])

        expect(run['name']).to eq(@name)
        expect(run['description']).to eq(@description)
        expect(run['milestone_id']).to be_nil
        expect(run['assignedto_id']).to be_nil
        expect(run['include_all']).to be true # Default true
        expect(run['is_completed']).to be false
        expect(run['plan_id']).to be_nil

        @client.delete_run(run['id'])
        expect { @client.get_run(run['id']) }.to raise_error(TestRail::APIError, 'TestRail API returned HTTP 400 ("Field :run is not a valid test run.")')
      end

      it 'can add/close test run ' do
        payload = @client.get_default_payload(@name, @description)

        run = @client.add_run(payload.compact)
        run_id = run['id']
        expect(run['is_completed']).to be false

        @client.close_run(run_id)

        run = @client.get_run(run_id)
        expect(run['is_completed']).to be true
      end
    end
  end
end
