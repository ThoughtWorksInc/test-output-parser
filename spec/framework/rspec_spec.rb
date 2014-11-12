require 'spec_helper'

describe TestOutputParser::Framework::RSpec do
  it 'should do nothing when there is no spec summary in the output' do
    TestOutputParser::Framework::RSpec.count("123 foo  bar examples").to_hash.should == {}
  end

  it 'should count the number of specs ran for one example' do
    TestOutputParser::Framework::RSpec.count("1 example, 0 failures").to_hash.should == {:total => 1}
  end

  it 'should count the number of specs ran for one rspec run' do
    TestOutputParser::Framework::RSpec.count("25 examples, 0 failures").to_hash.should == {:total => 25}
  end

  it 'should count the number of specs ran for multiple rspec runs' do
    TestOutputParser::Framework::RSpec.count("25 examples, 1 failure\n\n\n5 examples, 3 failures").to_hash.should == {:total => 30, :failed => 4}
  end

  it 'should ignore lines not related to rspec test summary' do
    TestOutputParser::Framework::RSpec.count(File.read("spec/fixtures/sample-rspec-output.txt")).to_hash.should == {:total => 67}
  end

  it 'should count the number of pending specs' do
    TestOutputParser::Framework::RSpec.count("16 examples, 0 failures, 1 pending").to_hash.should == {:total => 16, :pending => 1}
  end

  it 'should count the name of the specs that failed' do
    TestOutputParser::Framework::RSpec.count(File.read("spec/fixtures/sample-failed-rspec-output.txt")).to_hash.should ==
        {
          :total => 16,
          :failed => 1,
          :failures =>  '' +
                        "  1) PostsController GET index assigns all posts as @posts\n" +
                        "     Failure/Error: assert false\n" +
                        "     MiniTest::Assertion:\n" +
                        "       Failed assertion, no message given.\n" +
                        "     # (eval):2:in `assert'\n" +
                        "     # ./spec/controllers/posts_controller_spec.rb:39:in `block (3 levels) in <top (required)>'\n\n"

        }
  end
end
