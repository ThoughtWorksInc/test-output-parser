module TestOutputParser
  module Framework
    class TestUnit
      def self.count(test_output, summary=Summary.new)
        test_output.scan(/(\d+)\s+test[s]?,\s+(\d+)\s+assertion[s]?(,\s*(\d+)\s+failures)?(,\s*(\d+)\s+error[s]?)?(,\s*(\d+)\s+skip[s]?)?/).each do |arr|
          summary.add_total       arr[0].to_i
          summary.add_failed      arr[3].to_i
          summary.add_errors      arr[5].to_i
          summary.add_pending     arr[7].to_i
        end


        failures = test_output.scan(/(^\s+\d+\)\sFailure:\n+.*)+\n\n^\d+\stests/m)
        summary.add_failure_lines(failures)

        summary
      end
    end
  end
end
