module TestOutputParser
  module Framework
    class RSpec
      def self.count(test_output, summary=Summary.new)
        test_output.scan(/(\d+)\s+example[s]?,\s+(\d+)\s+failure[s]?(,\s*(\d+)\s+pending)?/).each do |arr|
          summary.add_total   arr[0].to_i
          summary.add_failed  arr[1].to_i
          summary.add_pending arr[3].to_i
        end

        failures = test_output.scan(/Failures:\n+(.*)^Finished in/m)
        summary.add_failure_lines(failures)
        summary
      end
    end
  end
end
