require 'rspec'
require_relative './testrail'
require_relative './testrail_client'

RSpec.describe 'TestRail API' do
  it 'can get/create/delete test plan' do
    client = TestRail::TestRailClient.new(ENV['TESTRAIL_URL'])

    plan = client.create_test_plan('TestRailClientでつくったやーつ', '説明もかけます')
    expect(plan).not_to be_nil

    plan_id = plan['id']
    plan = client.get_plan(plan_id)
    expect(plan['id']).to eq(plan_id)

    client.delete_test_plan(plan_id)
    expect { client.get_plan(plan_id) }.to raise_error(TestRail::APIError, 'TestRail API returned HTTP 400 ("Field :plan_id is not a valid test plan.")')
  end
end
