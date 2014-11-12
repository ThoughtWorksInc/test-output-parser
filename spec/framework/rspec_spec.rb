require 'spec_helper'

describe TestOutputParser::Framework::RSpec do
  it 'should do nothing when there is no spec summary in the output' do
    actual = TestOutputParser::Framework::RSpec.count("123 foo  bar examples").to_hash
    expect(actual).to eq({})
  end

  it 'should count the number of specs ran for one example' do
    actual = TestOutputParser::Framework::RSpec.count("1 example, 0 failures").to_hash
    expected = { :total => 1 }
    expect(actual).to eq(expected)
  end

  it 'should count the number of specs ran for one rspec run' do
    actual = TestOutputParser::Framework::RSpec.count("25 examples, 0 failures").to_hash
    expected = { :total => 25 }
    expect(actual).to eq(expected)
  end

  it 'should count the number of specs ran for multiple rspec runs' do
    actual = TestOutputParser::Framework::RSpec.count("25 examples, 1 failure\n\n\n5 examples, 3 failures").to_hash
    expected = { :total => 30, :failed => 4 }
    expect(actual).to eq(expected)
  end

  it 'should ignore lines not related to rspec test summary' do
    actual = TestOutputParser::Framework::RSpec.count(File.read("spec/fixtures/sample-rspec-output.txt")).to_hash
    expected = { :total => 67 }
    expect(actual).to eq(expected)
  end

  it 'should count the number of pending specs' do
    actual = TestOutputParser::Framework::RSpec.count("16 examples, 0 failures, 1 pending").to_hash
    expected = { :total => 16, :pending => 1 }
    expect(actual).to eq(expected)
  end

  it 'should count the name of the specs that failed' do
    expected = {
      :total => 16,
      :failed => 1,
      :failures => '' +
        "  1) PostsController GET index assigns all posts as @posts\n" +
        "     Failure/Error: assert false\n" +
        "     MiniTest::Assertion:\n" +
        "       Failed assertion, no message given.\n" +
        "     # (eval):2:in `assert'\n" +
        "     # ./spec/controllers/posts_controller_spec.rb:39:in `block (3 levels) in <top (required)>'\n\n"

    }
    actual = TestOutputParser::Framework::RSpec.count(File.read("spec/fixtures/sample-failed-rspec-output.txt")).to_hash

    expect(actual).to eq(expected)
  end
end
