# frozen_string_literal: true

require_relative './testrail'
require_relative './version'
require_relative './api/attachments'
require_relative './api/cases'
require_relative './api/case_fields'
require_relative './api/case_types'
require_relative './api/configurations'
require_relative './api/milestones'
require_relative './api/plans'
require_relative './api/priorities'
require_relative './api/projects'
require_relative './api/reports'
require_relative './api/results'
require_relative './api/result_fields'
require_relative './api/runs'
require_relative './api/sections'
require_relative './api/statuses'
require_relative './api/suites'
require_relative './api/templates'
require_relative './api/tests'
require_relative './api/users'

module TestRail
  class Client < TestRail::APIClient

    include ::TestRail::API::Attachments
    include ::TestRail::API::Cases
    include ::TestRail::API::CaseFields
    include ::TestRail::API::CaseTypes
    include ::TestRail::API::Configurations
    include ::TestRail::API::Milestones
    include ::TestRail::API::Plans
    include ::TestRail::API::Priorities
    include ::TestRail::API::Projects
    include ::TestRail::API::Reports
    include ::TestRail::API::Results
    include ::TestRail::API::ResultFields
    include ::TestRail::API::Runs
    include ::TestRail::API::Sections
    include ::TestRail::API::Statuses
    include ::TestRail::API::Suites
    include ::TestRail::API::Template
    include ::TestRail::API::Tests
    include ::TestRail::API::Users

    def initialize(
        testrail_url: TestRail.config.testrail_url,
        testrail_user: TestRail.config.testrail_user,
        testrail_password: TestRail.config.testrail_password
    )
      raise 'Please set url of TestRail API. e.g. export TESTRAIL_URL' unless testrail_url
      raise 'Please set user of TestRail API. e.g. export TESTRAIL_USER' unless testrail_user
      raise 'Please set password of TestRail API. e.g. export TESTRAIL_PASSWORD' unless testrail_password

      super(testrail_url)

      @user = testrail_user
      @password = testrail_password
    end
  end
end
