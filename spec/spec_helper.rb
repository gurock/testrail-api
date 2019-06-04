# frozen_string_literal: true

require 'rspec'
require 'pry'

Dir[File.expand_path('../lib/**/*.rb', __dir__)].each { |f| require f }
