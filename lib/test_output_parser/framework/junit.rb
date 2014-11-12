module TestOutputParser
  module Framework
    class JUnit
      def self.count(test_output, summary=Summary.new)
        # normal junit
        test_output.scan(/Running\s+.*$\nTest[s]?\s+run:\s+(\d+),\s+Failure[s]?:\s+(\d+),\s+Error[s]?:\s+(\d+),\s+Skipped:\s+(\d+)/).each do |arr|
          summary.add_total arr[0].to_i
          summary.add_failed arr[1].to_i
          summary.add_errors arr[2].to_i
          summary.add_pending arr[3].to_i
        end

        # junit on gradle
        test_output.scan(/(\d+)\s+test[s]?\s+completed,\s+(\d+)\s+failed/).each do |arr|
          summary.add_total arr[0].to_i
          summary.add_failed arr[1].to_i
        end

        # normal junit
        failures = test_output.scan(/^(Failed\stests:\s+.*)^Tests run/m)
        summary.add_failure_lines(failures)

        # gradle junit errors
        if failures.empty?
          failures = test_output.scan(/^Running\stest:\s.*\n\n.*\s+FAILED\n.*/)
          summary.add_failure_lines(failures)
        end

        summary
      end
    end
  end
end
