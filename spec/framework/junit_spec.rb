require 'spec_helper'

describe TestOutputParser::Framework::JUnit do
  it 'should do nothing when there is no spec summary in the output' do
    expect(TestOutputParser::Framework::JUnit.count("Tests not run").to_hash).to eq({})
  end

  it 'should count the number of specs ran for one example' do
    actual = TestOutputParser::Framework::JUnit.count("Running com.foo.microblog.core.ErrorResponseTest\nTests run: 1, Failures: 0, Errors: 0, Skipped: 0").to_hash
    expected = { :total => 1 }
    expect(actual).to eq(expected)
  end

  it 'should count the number of specs ran for one JUnit run' do
    actual = TestOutputParser::Framework::JUnit.count("Running com.foo.microblog.core.ErrorResponseTest\nTests run: 10, Failures: 1, Errors: 5, Skipped: 3").to_hash
    expected = { :total => 10, :failed => 1, :errors => 5, :pending => 3 }
    expect(actual).to eq(expected)
  end

  it 'should count the number of specs ran for multiple JUnit runs' do
    actual = TestOutputParser::Framework::JUnit.count("Running com.foo.microblog.core.ErrorResponseTest\nTests run: 10, Failures: 1, Errors: 5, Skipped: 3\n\n\n" +
                                                        "Running com.foo.microblog.core.UserResourceTest\nTests run: 1, Failures: 0, Errors: 0, Skipped: 0").to_hash

    expected = { :total => 11, :failed => 1, :errors => 5, :pending => 3 }
    expect(actual).to eq(expected)
  end

  it 'should handle gradle output' do
    actual = TestOutputParser::Framework::JUnit.count("47 tests completed, 1 failed").to_hash
    expected = { :total => 47, :failed => 1 }
    expect(actual).to eq(expected)
  end

  it 'should ignore lines not related to JUnit test summary' do
    actual = TestOutputParser::Framework::JUnit.count(File.read("spec/fixtures/sample-junit-output.txt")).to_hash
    expected = { :total => 13 }
    expect(actual).to eq(expected)
  end

  it 'should include the failures in the test summary for JUnit output' do
    actual = TestOutputParser::Framework::JUnit.count(File.read("spec/fixtures/sample-failed-junit-output.txt")).to_hash
    expected = {
      :total => 13,
      :failed => 2,
      :failures => '' +
        "Failed tests:   testFromExceptionWithUniqueConstraintViolation(com.snapci.microblog.core.ErrorResponseTest)\n" +
        "  testFromException(com.snapci.microblog.core.ErrorResponseTest)\n\n"
    }
    expect(actual).to eq(expected)
  end

  it 'should include the failures in the test summary for gradle output' do
    actual = TestOutputParser::Framework::JUnit.count(File.read("spec/fixtures/sample-gradle-output.txt")).to_hash
    expected = {
      :total => 47,
      :failed => 1,
      :failures => ''+
        "Running test: test shouldAddBookToDBIfNotInSystem(com.thoughtworks.twu.controller.AddBookControllerTest)\n\n" +
        "com.thoughtworks.twu.controller.AddBookControllerTest > shouldAddBookToDBIfNotInSystem FAILED\n" +
        "    java.lang.AssertionError at AddBookControllerTest.java:28"
    }
    expect(actual).to eq(expected)
  end
end
