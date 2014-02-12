require 'spec_helper'

describe TestOutputParser::Framework::TestUnit do
  it 'should do nothing when there is no spec summary in the output' do
    TestOutputParser::Framework::TestUnit.count("1 assertion").should == {}
  end

  it 'should count the number of tests ran for one test' do
    TestOutputParser::Framework::TestUnit.count("1 tests, 1 assertions").should == {:total => 1, :failed => 0, :errors => 0, :pending => 0}
  end

  it 'should count the number of specs ran for one test-unit run' do
    TestOutputParser::Framework::TestUnit.count("30 tests, 77 assertions, 3 failures, 4 errors, 2 skips").should ==
      {:total => 30, :failed => 3, :errors => 4, :pending => 2}
  end

  it 'should count the number of specs ran for multiple test-unit runs' do
    TestOutputParser::Framework::TestUnit.count("30 tests, 77 assertions, 0 failures\n\n\n1 tests, 3 assertions, 1 failures, 1 errors, 1 skips").should ==
      {:total => 31, :failed => 1, :errors => 1, :pending => 1}
  end

  it 'should ignore lines not related to test-unit test summary' do
    TestOutputParser::Framework::TestUnit.count(File.read("spec/fixtures/sample-test-unit-output.txt")).should == {:total => 1, :failed => 0, :errors => 0, :pending => 0}
  end

  it 'should count the number of specs errors' do
    TestOutputParser::Framework::TestUnit.count(File.read("spec/fixtures/sample-error-test-unit-output.txt")).should == {:total => 1, :failed => 0, :errors => 1, :pending => 0}
  end

  it 'should count the number of specs pending' do
    TestOutputParser::Framework::TestUnit.count(File.read("spec/fixtures/sample-pending-test-unit-output.txt")).should == {:total => 1, :failed => 0, :errors => 0, :pending => 1}
  end

  it 'should add the failures to the summary' do
    TestOutputParser::Framework::TestUnit.count(File.read("spec/fixtures/sample-failed-test-unit-output.txt")).should ==
      {
        :total => 3,
        :failed => 2,
        :errors => 0,
        :pending => 0,
        :failures => "\n  1) Failure:\n" \
          "test_passes(FooTest) [/var/go/repo/test/foo_test.rb:5]:\n" \
          "Failed assertion, no message given.\n"\
                     "\n  2) Failure:\n"\
          "test_passes(FooTest) [/var/go/repo/test/foo_test.rb:10]:\n"\
          "Failed assertion, no message given."
      }
  end
end