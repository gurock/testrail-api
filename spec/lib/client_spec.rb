# frozen_string_literal: true

RSpec.describe 'TestRail API' do
  it 'can get/create/delete test plan' do
    client = TestRail::Client.new(ENV['TESTRAIL_URL'])

    plan = client.add_plan('Clientでつくったやーつ', '説明もかけます')
    expect(plan).not_to be_nil

    plan_id = plan['id']
    plan = client.get_plan(plan_id)
    expect(plan['id']).to eq(plan_id)

    client.delete_plan(plan_id)
    expect { client.get_plan(plan_id) }.to raise_error(TestRail::APIError, 'TestRail API returned HTTP 400 ("Field :plan_id is not a valid test plan.")')
  end
end
