require 'test_output_parser/version'
require 'test_output_parser/framework'

module TestOutputParser
  def self.count(test_output, framework)
    return TestOutputParser::Framework::RSpec.count(test_output)    if framework == :rspec
    return TestOutputParser::Framework::TestUnit.count(test_output) if framework == :test_unit

    raise ArgumentError.new("Invalid argument")
  end
end