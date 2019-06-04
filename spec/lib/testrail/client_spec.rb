# frozen_string_literal: true

RSpec.describe 'TestRail' do
  context 'Client' do
    it 'can use initialize_all_param method' do
      client = TestRail::Client.new('https://daipresents.com')
      new_user = 'new_user'
      new_password = 'new_password'
      new_project_id = 'new_project_id'
      client.initialize_all_param(new_user, new_password, new_project_id)
      expect(client.user).to eq(new_user)
      expect(client.password).to eq(new_password)
      expect(client.project_id).to eq(new_project_id)
    end
  end
end
