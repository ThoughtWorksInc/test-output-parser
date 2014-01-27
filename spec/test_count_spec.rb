require 'spec_helper'

describe TestCount do
  it 'should count the number of specs ran for one rspec run' do
    TestCount.count("25 examples, 0 failures").should == [25, 0]
  end

  xit 'should count the number of specs ran for multiple rspec runs' do
    TestCount.count("25 examples, 0 failures\n5 examples, 3 failures").should == [30, 3]
  end
end