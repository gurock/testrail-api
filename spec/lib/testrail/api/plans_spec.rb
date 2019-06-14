# frozen_string_literal: true

RSpec.describe 'TestRail' do
  context 'API' do
    context 'Plans' do
      before(:each) do
        @client = TestRail::Client.new(TestRail.config.testrail_url)
        @name = 'Test Plan Name'
        @description = 'Test Plan Description'
      end

      it 'can get/create/delete test plan' do
        plan = @client.add_plan(@name, @description)
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

        name2 = "#{@name}2"
        description2 = "#{@description}2"

        @client.add_plan(name1, description1)
        @client.add_plan(name2, description2)

        plans = @client.get_plans
        expect(plans[0]['name']).to eq(name2)
        expect(plans[0]['description']).to eq(description2)
        expect(plans[1]['name']).to eq(name1)
        expect(plans[1]['description']).to eq(description1)
      end

      it 'can close test plan' do
        plan = @client.add_plan('Clientでつくったやーつ', '説明もかけます')
        plan_id = plan['id']
        expect(plan['is_completed']).to be false

        @client.close_plan(plan_id)

        plan = @client.get_plan(plan_id)
        expect(plan['is_completed']).to be true
      end
    end
  end
end
