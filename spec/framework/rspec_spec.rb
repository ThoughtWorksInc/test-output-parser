require 'spec_helper'

describe TestOutputParser::Framework::RSpec do
  it 'should do nothing when there is no spec summary in the output' do
    TestOutputParser::Framework::RSpec.count("123 foo  bar examples").should == {}
  end

  it 'should count the number of specs ran for one example' do
    TestOutputParser::Framework::RSpec.count("1 example, 0 failures").should == {:total => 1, :failed => 0, :pending => 0}
  end

  it 'should count the number of specs ran for one rspec run' do
    TestOutputParser::Framework::RSpec.count("25 examples, 0 failures").should == {:total => 25, :failed => 0, :pending => 0}
  end

  it 'should count the number of specs ran for multiple rspec runs' do
    TestOutputParser::Framework::RSpec.count("25 examples, 1 failure\n\n\n5 examples, 3 failures").should == {:total => 30, :failed => 4, :pending => 0}
  end

  it 'should ignore lines not related to rspec test summary' do
    TestOutputParser::Framework::RSpec.count(File.read("spec/fixtures/sample-rspec-output.txt")).should == {:total => 67, :failed => 0, :pending => 0}
  end

  it 'should count failures correctly' do
    TestOutputParser::Framework::RSpec.count(File.read("spec/fixtures/sample-failed-rspec-output.txt")).should == {:total => 16, :failed => 1, :pending => 0}
  end

  it 'should count the number of pending specs' do
    TestOutputParser::Framework::RSpec.count("16 examples, 0 failures, 1 pending").should == {:total => 16, :failed => 0, :pending => 1}
  end
end