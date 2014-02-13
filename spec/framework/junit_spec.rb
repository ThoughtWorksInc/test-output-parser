require 'spec_helper'

describe TestOutputParser::Framework::JUnit do
  it 'should do nothing when there is no spec summary in the output' do
    TestOutputParser::Framework::JUnit.count("Tests not run").should == {}
  end

  it 'should count the number of specs ran for one example' do
    TestOutputParser::Framework::JUnit.count("Running com.foo.microblog.core.ErrorResponseTest\nTests run: 1, Failures: 0, Errors: 0, Skipped: 0").should ==
      {:total => 1, :failed => 0, :errors => 0, :pending => 0}
  end

  it 'should count the number of specs ran for one JUnit run' do
    TestOutputParser::Framework::JUnit.count("Running com.foo.microblog.core.ErrorResponseTest\nTests run: 10, Failures: 1, Errors: 5, Skipped: 3").should ==
      {:total => 10, :failed => 1, :errors => 5, :pending => 3}
  end

  it 'should count the number of specs ran for multiple JUnit runs' do
    TestOutputParser::Framework::JUnit.count("Running com.foo.microblog.core.ErrorResponseTest\nTests run: 10, Failures: 1, Errors: 5, Skipped: 3\n\n\n" \
    "Running com.foo.microblog.core.UserResourceTest\nTests run: 1, Failures: 0, Errors: 0, Skipped: 0").should ==
      {:total => 11, :failed => 1, :errors => 5, :pending => 3}
  end

  it 'should handle gradle output' do
    TestOutputParser::Framework::JUnit.count("47 tests completed, 1 failed").should == {:total => 47, :failed => 1}
  end

  it 'should ignore lines not related to JUnit test summary' do
    TestOutputParser::Framework::JUnit.count(File.read("spec/fixtures/sample-junit-output.txt")).should == {:total => 13, :failed => 0, :errors => 0, :pending => 0}
  end

  it 'should include the failures in the test summary for JUnit output' do
    TestOutputParser::Framework::JUnit.count(File.read("spec/fixtures/sample-failed-junit-output.txt")).should ==
      {
        :total => 13,
        :failed => 2,
        :errors=>0,
        :pending=>0,
          :failures => "Failed tests:   testFromExceptionWithUniqueConstraintViolation(com.snapci.microblog.core.ErrorResponseTest)\n"\
                      "  testFromException(com.snapci.microblog.core.ErrorResponseTest)"
      }
  end

  it 'should include the failures in the test summary for gradle output' do
    TestOutputParser::Framework::JUnit.count(File.read("spec/fixtures/sample-gradle-output.txt")).should ==
      {
        :total => 47,
        :failed => 1,
        :failures => "Running test: test shouldAddBookToDBIfNotInSystem(com.thoughtworks.twu.controller.AddBookControllerTest)\n\n"\
                      "com.thoughtworks.twu.controller.AddBookControllerTest > shouldAddBookToDBIfNotInSystem FAILED\n"\
                      "    java.lang.AssertionError at AddBookControllerTest.java:28"
      }
  end
end