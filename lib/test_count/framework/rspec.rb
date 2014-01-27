module TestCount
  module Framework
    class RSpec
      def self.count(test_output)
        total_specs, failed_specs = 0
        test_output.scan(/(\d+) examples, (\d+) failures/).each do |arr|
          total_specs  = arr[0].to_i
          failed_specs = arr[1].to_i
        end

        [total_specs, failed_specs]
      end
    end
  end
end