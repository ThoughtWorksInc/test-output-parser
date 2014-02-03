require 'spec_helper'

describe TestOutputParser do
  it 'should give the summary of specs for rspec' do
    TestOutputParser.count(File.read("spec/fixtures/sample-failed-rspec-output.txt"), :rspec).should == {:total => 1460, :failed => 1, :pending => 3}
  end

  it 'should give the summary of specs for test unit' do
    TestOutputParser.count(File.read("spec/fixtures/sample-failed-test-unit-output.txt"), :test_unit).should == {:total => 1, :assertions => 1, :failed => 1, :errors => 0, :skipped => 0}
  end

  it 'should raise an error when a valid framework is not specified' do
    lambda do
      TestOutputParser.count("foo", :bar)
    end.should raise_error(ArgumentError)
  end
end