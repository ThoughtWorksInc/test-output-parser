module TestCount
  module Framework
    class RSpec
      def self.count(test_output)
        total_specs, failed_specs, pending_specs = 0, 0, 0
        test_output.scan(/(\d+)\s+example[s]?,\s+(\d+)\s+failure[s]?(,\s*(\d+)\s+pending)?/).each do |arr|
          total_specs  += arr[0].to_i
          failed_specs += arr[1].to_i
          pending_specs += arr[3].to_i
        end

        [total_specs, failed_specs, pending_specs]
      end
    end
  end
end