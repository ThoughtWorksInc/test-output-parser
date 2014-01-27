require 'spec_helper'

describe TestCount do
  it 'should count the number of specs ran for one example' do
    TestCount.count("1 example, 0 failures").should == [1, 0, 0]
  end

  it 'should count the number of specs ran for one rspec run' do
    TestCount.count("25 examples, 0 failures").should == [25, 0, 0]
  end

  it 'should count the number of specs ran for multiple rspec runs' do
    TestCount.count("25 examples, 1 failure\n\n\n5 examples, 3 failures").should == [30, 4, 0]
  end

  it 'should ignore lines not related to rspec test summary' do
    TestCount.count(File.read("spec/fixtures/sample-rspec-output.txt")).should == [67, 0, 0]
  end

  it 'should count failures correctly' do
    TestCount.count(File.read("spec/fixtures/sample-failed-rspec-output.txt")).should == [1460, 1, 3]
  end

  it 'should count the number of pending specs' do
    TestCount.count(File.read("spec/fixtures/sample-failed-rspec-output.txt")).should == [1460, 1, 3]
  end
end