# frozen_string_literal: true

RSpec.describe 'TestRail' do
  context 'API' do
    context 'Plans' do
      before(:each) do
        @project_id = RSpec.current_example.metadata[:project_id]
        @client = TestRail::Client.new
        @name = 'Test Plan Name'
        @description = 'Test Plan Description'
      end

      it 'can get/create/delete test plan' do
        payload = @client.payload_for_adding_plan
        payload[:name] = @name
        payload[:description] = @description
        plan = @client.add_plan(@project_id, payload)
        expect(plan).not_to be_nil

        plan_id = plan['id']
        plan = @client.get_plan(plan_id)
        expect(plan['id']).to eq(plan_id)

        @client.delete_plan(plan_id)
        expect { @client.get_plan(plan_id) }.to raise_error(TestRail::APIError, 'TestRail API returned HTTP 400 ("Field :plan_id is not a valid test plan.")')
      end

      it 'can get test plans' do
        name1 = "#{@name}1"
        description1 = "#{@description}1"
        payload = @client.payload_for_adding_plan
        payload[:name] = name1
        payload[:description] = description1
        @client.add_plan(@project_id, payload)

        name2 = "#{@name}2"
        description2 = "#{@description}2"
        payload[:name] = name2
        payload[:description] = description2
        @client.add_plan(@project_id, payload)

        plans = @client.get_plans(@project_id)
        expect(plans[0]['name']).to eq(name2)
        expect(plans[0]['description']).to eq(description2)
        expect(plans[1]['name']).to eq(name1)
        expect(plans[1]['description']).to eq(description1)
      end

      it 'can close test plan' do
        payload = @client.payload_for_adding_plan
        payload[:name] = @name
        payload[:description] = @description
        plan = @client.add_plan(@project_id, payload)
        plan_id = plan['id']
        expect(plan['is_completed']).to be false

        @client.close_plan(plan_id)

        plan = @client.get_plan(plan_id)
        expect(plan['is_completed']).to be true
      end

      it 'get default payload' do
        payload = @client.payload_for_adding_plan

        expect(payload[:name]).to be_nil
        expect(payload[:description]).to be_nil
        expect(payload[:milestone_id]).to be_nil
        expect(payload[:entries]).to be_nil
      end
    end
  end
end
