module TestOutputParser
  module Framework
    class TestUnit
      def self.count(test_output, summary=Hash.new(0))
        test_output.scan(/(\d+)\s+test[s]?,\s+(\d+)\s+assertion[s]?(,\s*(\d+)\s+failures)?(,\s*(\d+)\s+error[s]?)?(,\s*(\d+)\s+skip[s]?)?/).each do |arr|
          summary[:total]      += arr[0].to_i
          #summary[:assertions] += arr[1].to_i
          summary[:failed]     += arr[3].to_i
          summary[:errors]     += arr[5].to_i
          summary[:pending]    += arr[7].to_i
        end

        failures = test_output.scan(/(^\s+\d\)\sFailure:\n+.*)+\d+\stests/m)
        summary[:failures] = failures.flatten.first.strip unless failures.empty?
        summary
      end
    end
  end
end