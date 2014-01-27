require 'test_output_parser/version'
require 'test_output_parser/framework'

module TestOutputParser
  def self.count(test_output)
    TestOutputParser::Framework::RSpec.count(test_output)
  end
end