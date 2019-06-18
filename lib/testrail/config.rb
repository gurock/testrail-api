require 'logger'
require 'active_support/configurable'

module TestRail
  def self.configure(&block)
    @config = Config.new
    yield @config if block_given?
  end

  def self.config
    @config ||= Config.new
  end

  class Config
    include ActiveSupport::Configurable
    config_accessor :testrail_url, :testrail_user, :testrail_password, :logger

    def initialize
      default_config
    end

    def default_config
      self.testrail_url = ENV['TESTRAIL_URL']
      self.testrail_user = ENV['TESTRAIL_USER']
      self.testrail_password = ENV['TESTRAIL_PASSWORD']
      self.logger = Logger.new STDOUT
    end
  end
end