module TestOutputParser
  module Framework
    class JUnit
      def self.count(test_output, summary=Hash.new(0))
        test_output.scan(/Running\s+.*$\nTest[s]?\s+run:\s+(\d+),\s+Failure[s]?:\s+(\d+),\s+Error[s]?:\s+(\d+),\s+Skipped:\s+(\d+)/).each do |arr|
          summary[:total]   += arr[0].to_i
          summary[:failed]  += arr[1].to_i
          summary[:errors]  += arr[2].to_i
          summary[:pending] += arr[3].to_i
        end

        test_output.scan(/(\d+)\s+test[s]?\s+completed,\s+(\d+)\s+failed/).each do |arr|
          summary[:total]   += arr[0].to_i
          summary[:failed]  += arr[1].to_i
        end

        summary
      end
    end
  end
end