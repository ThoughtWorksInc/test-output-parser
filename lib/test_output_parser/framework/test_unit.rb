module TestOutputParser
  module Framework
    class TestUnit
      def self.count(test_output)
        summary = Hash.new(0)
        test_output.scan(/(\d+)\s+test[s]?,\s+(\d+)\s+assertion[s]?(,\s*(\d+)\s+failures)?(,\s*(\d+)\s+error[s]?)?(,\s*(\d+)\s+skip[s]?)?/).each do |arr|
          summary[:total]      += arr[0].to_i
          summary[:assertions] += arr[1].to_i
          summary[:failed]     += arr[3].to_i
          summary[:errors]     += arr[5].to_i
          summary[:skipped]    += arr[7].to_i
        end

        summary
      end
    end
  end
end