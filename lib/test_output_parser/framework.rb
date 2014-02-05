require 'test_output_parser/framework/rspec'
require 'test_output_parser/framework/test_unit'
require 'test_output_parser/framework/junit'

module TestOutputParser
  module Framework
    def count(test_output)
      raise 'Sub class responsibility'
    end
  end
end