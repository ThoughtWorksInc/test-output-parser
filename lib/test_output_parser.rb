require 'test_output_parser/version'
require 'test_output_parser/framework'
require 'stringio'

module TestOutputParser

  class Summary

    ATTRIBUTES = %w(total failed errors pending)

    ATTRIBUTES.each do |suffix|
      class_eval <<-RUBY_EVAL, __FILE__, __LINE__ + 1
        attr_accessor :#{suffix}

        def add_#{suffix}(to_add)
          self.#{suffix} += to_add
        end

        def #{suffix}
          @#{suffix} ||= 0
        end

      RUBY_EVAL
    end

    def add_failure_lines(lines)
      return unless lines
      return if lines.respond_to?(:empty?) && lines.empty?
      if lines.respond_to?(:to_str)
        self.failures << lines
      else
        self.failures << lines.join
      end
    end

    def failures
      @failures ||= StringIO.new
    end

    def to_hash
      result = {}
      ATTRIBUTES.each do |attr|
        next if self.send(attr) == 0
        result[attr.to_sym] = self.send(attr)
      end

      if failures.size != 0
        result[:failures] = failures.string
      end

      result
    end

  end

  def self.count(test_output)
    summary = Summary.new

    TestOutputParser::Framework::RSpec.count(test_output, summary)
    TestOutputParser::Framework::TestUnit.count(test_output, summary)
    TestOutputParser::Framework::JUnit.count(test_output, summary)

    summary.to_hash
  end
end
