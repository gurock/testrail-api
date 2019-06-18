# frozen_string_literal: true

require_relative './testrail'
require_relative './version'
require_relative './api/plans'
require_relative './api/projects'
require_relative './api/results'
require_relative './api/runs'

module TestRail
  class Client < TestRail::APIClient

    include ::TestRail::API::Plans
    include ::TestRail::API::Projects
    include ::TestRail::API::Results
    include ::TestRail::API::Runs

    @project_id = ''

    attr_accessor :project_id

    def self.check_env_value
      raise 'Please set TESTRAIL_URL. e.g. export TESTRAIL_URL=https://yourdomain.testrai.io/' unless TestRail.config.testrail_url
      raise 'Please set TESTRAIL_USER. e.g. export TESTRAIL_USER=${EMAIL}' unless  TestRail.config.testrail_user
      raise 'Please set TESTRAIL_PASSWORD. e.g. export TESTRAIL_PASSWORD=${API_KEY}' unless  TestRail.config.testrail_password
      raise 'Please set TESTRAIL_PROJECT_ID. e.g. export TESTRAIL_PROJECT_ID=${NUMBER}' unless  TestRail.config.testrail_project_id
    end

    def initialize(base_url)
      Client.check_env_value

      super(base_url)
      initialize_all_param(TestRail.config.testrail_user, TestRail.config.testrail_password, TestRail.config.testrail_project_id)
    end

    def initialize_all_param(user, password, project_id)
      @user = user
      @password = password
      @project_id = project_id
    end
  end
end
