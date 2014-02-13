require 'spec_helper'

describe TestOutputParser do
  it 'should give the summary of specs for rspec' do
    TestOutputParser.count(File.read("spec/fixtures/sample-failed-rspec-output.txt")).should ==
      {
        :total=>16,
        :failed=>1,
        :pending=>0,
        :failures=>"1) PostsController GET index assigns all posts as @posts\n"\
        "     Failure/Error: assert false\n"\
        "     MiniTest::Assertion:\n"\
        "       Failed assertion, no message given.\n"\
        "     # (eval):2:in `assert'\n"\
        "     # ./spec/controllers/posts_controller_spec.rb:39:in `block (3 levels) in <top (required)>'"
      }
  end

  it 'should give the summary of specs for test unit' do
    TestOutputParser.count(File.read("spec/fixtures/sample-failed-test-unit-output.txt")).should ==
      {
        :total=>3,
        :failed=>2,
        :errors=>0,
        :pending=>0,
        :failures=>"1) Failure:\ntest_passes(FooTest) [/var/go/repo/test/foo_test.rb:5]:\n"\
        "Failed assertion, no message given.\n\n"\
        "  2) Failure:\ntest_passes(FooTest) [/var/go/repo/test/foo_test.rb:10]:\nFailed assertion, no message given."
      }
  end

  it 'should give the summary of specs for junit' do
    TestOutputParser.count(File.read("spec/fixtures/sample-gradle-output.txt")).should ==
      {
        :total=>47,
        :failed=>1,
        :failures=>"Running test: test shouldAddBookToDBIfNotInSystem(com.thoughtworks.twu.controller.AddBookControllerTest)\n\n"\
        "com.thoughtworks.twu.controller.AddBookControllerTest > shouldAddBookToDBIfNotInSystem FAILED\n"\
        "    java.lang.AssertionError at AddBookControllerTest.java:28"
      }
  end

  it 'should add up the summaries when there are specs for multiple frameworks' do
    TestOutputParser.count(File.read("spec/fixtures/sample-failed-test-unit-output.txt") + File.read("spec/fixtures/sample-failed-rspec-output.txt")).should ==
      {
        :total=>19,
        :failed=>3,
        :pending=>0,
        :failures=>"1) Failure:\n"\
        "test_passes(FooTest) [/var/go/repo/test/foo_test.rb:5]:\n"\
        "Failed assertion, no message given.\n\n"\
        "  2) Failure:\ntest_passes(FooTest) [/var/go/repo/test/foo_test.rb:10]:\n"\
        "Failed assertion, no message given.",
        :errors=>0
      }
  end
end