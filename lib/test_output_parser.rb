require 'test_output_parser/version'
require 'test_output_parser/framework'

module TestOutputParser
  def self.count(test_output)
    summary = TestOutputParser::Framework::RSpec.count(test_output)
    TestOutputParser::Framework::TestUnit.count(test_output, summary)
    TestOutputParser::Framework::JUnit.count(test_output, summary)
  end
end