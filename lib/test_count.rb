require 'test_count/version'
require 'test_count/framework/framework'

module TestCount
  def self.count(test_output)
    TestCount::Framework::RSpec.count(test_output)
  end
end