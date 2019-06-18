# frozen_string_literal: true

RSpec.describe 'TestRail' do
  context 'Client' do
    it 'can create new client by using parameter' do
      url = 'http://daipresents.com'
      user = 'new_user'
      password = 'new_password'
      client = TestRail::Client.new(testrail_url: url, testrail_user: user, testrail_password: password)

      expect(client.user).to eq(user)
      expect(client.password).to eq(password)
    end

    it 'can create new client by env values' do
      expect(ENV['TESTRAIL_URL']).not_to be_nil
      expect(ENV['TESTRAIL_USER']).not_to be_nil
      expect(ENV['TESTRAIL_PASSWORD']).not_to be_nil

      client = TestRail::Client.new(
        testrail_url: ENV['TESTRAIL_URL'],
        testrail_user: ENV['TESTRAIL_USER'],
        testrail_password: ENV['TESTRAIL_PASSWORD'])

      expect(client.user).to eq(ENV['TESTRAIL_USER'])
      expect(client.password).to eq(ENV['TESTRAIL_PASSWORD'])
    end
  end
end
