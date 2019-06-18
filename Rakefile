require 'rspec/core/rake_task'
require_relative 'spec/spec_helper'

namespace :test do
  desc 'Test all specs'
  RSpec::Core::RakeTask.new(:all) do |spec|
    spec.pattern = FileList['spec/**/*']
    spec.pattern += FileList['spec/api/*']
  end
end