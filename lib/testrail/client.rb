# frozen_string_literal: true

require 'pry'
require_relative './testrail'
require_relative './version'

module TestRail
  class Client < TestRail::APIClient
    @project_id = ''

    attr_accessor :project_id

    def self.check_env_value
      raise 'Please set TESTRAIL_URL. e.g. export TESTRAIL_URL=https://yourdomain.testrai.io/' unless ENV['TESTRAIL_URL']
      raise 'Please set TESTRAIL_USER. e.g. export TESTRAIL_USER=${EMAIL}' unless ENV['TESTRAIL_USER']
      raise 'Please set TESTRAIL_PASSWORD. e.g. export TESTRAIL_PASSWORD=${API_KEY}' unless ENV['TESTRAIL_PASSWORD']
      raise 'Please set TESTRAIL_PROJECT_ID. e.g. export TESTRAIL_PROJECT_ID=${NUMBER}' unless ENV['TESTRAIL_PROJECT_ID']
    end

    def initialize(base_url)
      Client.check_env_value

      super(base_url)
      initialize_all_param(base_url, ENV['TESTRAIL_USER'], ENV['TESTRAIL_PASSWORD'], ENV['TESTRAIL_PROJECT_ID'])
    end

    def initialize_all_param(base_url, user, password, project_id)
      @user = user
      @password = password
      @project_id = project_id
    end

    def get_plan(plan_id)
      send_get("get_plan/#{plan_id}")
    end

    def create_test_plan(name = 'Test Plan. Created by API (Default)', description = '')
      send_post("add_plan/#{@project_id}", 'name': name, 'description': description)
    end

    def delete_test_plan(plan_id)
      send_post("delete_plan/#{plan_id}", nil)
    end

    def create_test_run

    end

    def update_test_case_result(example)

    end

    def update_manual_test_case_status

    end

    def get_testrail_id_from_tags(tags)

    end

    def get_jira_id_from_tags(tags)

    end

    def create_case_status(example)

    end

    def create_case_comment(example)

    end

    def create_descrption(example)

    end
  end
end
