# frozen_string_literal: true

require 'testrail/client'
require 'testrail/config'
require 'testrail/testrail'

module TestRail
  def self.logger
    TestRail.config.logger
  end
end