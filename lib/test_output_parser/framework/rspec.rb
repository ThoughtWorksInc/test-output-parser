module TestOutputParser
  module Framework
    class RSpec
      def self.count(test_output, summary=Hash.new(0))
        test_output.scan(/(\d+)\s+example[s]?,\s+(\d+)\s+failure[s]?(,\s*(\d+)\s+pending)?/).each do |arr|
          summary[:total]   += arr[0].to_i
          summary[:failed]  += arr[1].to_i
          summary[:pending] += arr[3].to_i
        end
        failures = test_output.scan(/Failures:\n+(.*)Finished in/m)
        summary[:failures] = failures.flatten.first.strip unless failures.empty?

        summary
      end
    end
  end
end