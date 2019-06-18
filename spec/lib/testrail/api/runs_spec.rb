# frozen_string_literal: true

RSpec.describe 'TestRail' do
  context 'API' do
    context 'Runs' do
      before(:each) do
        @project_id = RSpec.current_example.metadata[:project_id]
        @client = TestRail::Client.new
        @name = 'Test Run Name'
        @description = 'Test Run Description'
      end

      context '.add_run, .get_run, .delete_run' do
        it 'can add/get/delete test run ' do
          payload = @client.payload_for_adding_run
          payload[:name] = @name
          payload[:description] = @description

          run = @client.add_run(@project_id, payload.compact)
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
      end

      context '.get_runs' do
        it 'can get runs' do
          name1 = "#{@name}1"
          description1 = "#{@description}1"
          payload = @client.payload_for_adding_run
          payload[:name] = name1
          payload[:description] = description1
          @client.add_run(@project_id, payload.compact)

          name2 = "#{@name}2"
          description2 = "#{@description}2"
          payload[:name] = name2
          payload[:description] = description2
          @client.add_run(@project_id, payload.compact)

          runs = @client.get_runs(@project_id)
          expect(runs[0]['name']).to eq(name2)
          expect(runs[0]['description']).to eq(description2)
          expect(runs[1]['name']).to eq(name1)
          expect(runs[1]['description']).to eq(description1)
        end
      end

      context '.update_run' do
        it 'can update run' do
          payload = @client.payload_for_adding_run
          payload[:name] = @name
          payload[:description] = @description
          @client.add_run(@project_id, payload.compact)

          # Update
          name1 = "#{@name}1"
          description1 = "#{@description}1"
          payload = @client.payload_for_adding_run
          payload[:name] = name1
          payload[:description] = description1
          run = @client.add_run(@project_id, payload.compact)

          run = @client.get_run(run['id'])
          expect(run['name']).to eq(name1)
          expect(run['description']).to eq(description1)
        end
      end

      context '.close_run' do
        it 'can add/close test run ' do
          payload = @client.payload_for_adding_run
          payload[:name] = @name
          payload[:description] = @description

          run = @client.add_run(@project_id, payload.compact)
          run_id = run['id']
          expect(run['is_completed']).to be false

          @client.close_run(run_id)

          run = @client.get_run(run_id)
          expect(run['is_completed']).to be true
        end
      end

      context '.payload_for_run' do
        it 'get default payload' do
          payload = @client.payload_for_adding_run

          expect(payload[:name]).to be_nil
          expect(payload[:description]).to be_nil
          expect(payload[:suite_id]).to be_nil
          expect(payload[:milestone_id]).to be_nil
          expect(payload[:assignedto_id]).to be_nil
          expect(payload[:include_all]).to be_nil
          expect(payload[:case_ids]).to be_nil
          expect(payload[:unknown_parameter]).to be_nil
        end

        it 'get default payload with name and description' do
          payload = @client.payload_for_adding_run
          payload[:name] = @name
          payload[:description] = @description

          expect(payload[:name]).to eq(@name)
          expect(payload[:description]).to eq(@description)
        end
      end
    end
  end
end
