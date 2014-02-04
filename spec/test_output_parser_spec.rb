require 'spec_helper'

describe TestOutputParser do
  it 'should give the summary of specs for rspec' do
    TestOutputParser.count(File.read("spec/fixtures/sample-failed-rspec-output.txt")).should == {:total => 1460, :failed => 1, :pending => 3}
  end

  it 'should give the summary of specs for test unit' do
    TestOutputParser.count(File.read("spec/fixtures/sample-failed-test-unit-output.txt")).should == {:total => 1, :failed => 1, :errors => 0, :pending => 0}
  end

  it 'should add up the summaries when there are specs for multiple frameworks' do
    TestOutputParser.count(File.read("spec/fixtures/sample-failed-test-unit-output.txt") + File.read("spec/fixtures/sample-failed-rspec-output.txt")).should == {:total => 1461, :failed => 2, :errors => 0, :pending => 3}
  end
end