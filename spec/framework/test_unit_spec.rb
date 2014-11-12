require 'spec_helper'

describe TestOutputParser::Framework::TestUnit do
  it 'should do nothing when there is no spec summary in the output' do
    TestOutputParser::Framework::TestUnit.count("1 assertion").to_hash.should == {}
  end

  it 'should count the number of tests ran for one test' do
    TestOutputParser::Framework::TestUnit.count("1 tests, 1 assertions").to_hash.should == {:total => 1, }
  end

  it 'should count the number of specs ran for one test-unit run' do
    TestOutputParser::Framework::TestUnit.count("30 tests, 77 assertions, 3 failures, 4 errors, 2 skips").to_hash.should ==
      {:total => 30, :failed => 3, :errors => 4, :pending => 2}
  end

  it 'should count the number of specs ran for multiple test-unit runs' do
    TestOutputParser::Framework::TestUnit.count("30 tests, 77 assertions, 0 failures\n\n\n1 tests, 3 assertions, 1 failures, 1 errors, 1 skips").to_hash.should ==
      {:total => 31, :failed => 1, :errors => 1, :pending => 1}
  end

  it 'should ignore lines not related to test-unit test summary' do
    TestOutputParser::Framework::TestUnit.count(File.read("spec/fixtures/sample-test-unit-output.txt")).to_hash.should == {:total => 1, }
  end

  it 'should count the number of specs errors' do
    TestOutputParser::Framework::TestUnit.count(File.read("spec/fixtures/sample-error-test-unit-output.txt")).to_hash.should == {:total => 1, :errors => 1, }
  end

  it 'should count the number of specs pending' do
    TestOutputParser::Framework::TestUnit.count(File.read("spec/fixtures/sample-pending-test-unit-output.txt")).to_hash.should == {:total => 1, :pending => 1}
  end

  it 'should add the failures to the summary' do
    TestOutputParser::Framework::TestUnit.count(File.read("spec/fixtures/sample-failed-test-unit-output.txt")).to_hash.should ==
      {
        :total => 95,
        :failed => 1,
        :errors => 1,
        :failures => %Q!
  1) Failure:
test_no_additional_rubies(RubyTest) [/var/snap-ci/repo/test/packages/ruby_test.rb:23]:
--- expected
+++ actual
@@ -1 +1 @@
-["foo", "bar"]
+["baz", "boo"]


  2) Error:
test_rubies_are_installed(RubyTest):
Errno::ENOENT: No such file or directory - /opt/local/ruby/2.1.4/bin/ruby --version
    /tmp/.bundle-repo/ruby/1.9.1/gems/mixlib-shellout-1.2.0/lib/mixlib/shellout/unix.rb:268:in `exec'
    /tmp/.bundle-repo/ruby/1.9.1/gems/mixlib-shellout-1.2.0/lib/mixlib/shellout/unix.rb:268:in `block in fork_subprocess'
    /tmp/.bundle-repo/ruby/1.9.1/gems/mixlib-shellout-1.2.0/lib/mixlib/shellout/unix.rb:256:in `fork'
    /tmp/.bundle-repo/ruby/1.9.1/gems/mixlib-shellout-1.2.0/lib/mixlib/shellout/unix.rb:256:in `fork_subprocess'
    /tmp/.bundle-repo/ruby/1.9.1/gems/mixlib-shellout-1.2.0/lib/mixlib/shellout/unix.rb:40:in `run_command'
    /tmp/.bundle-repo/ruby/1.9.1/gems/mixlib-shellout-1.2.0/lib/mixlib/shellout.rb:225:in `run_command'
    /var/snap-ci/repo/test/mini_test_helper.rb:28:in `block in run_command'
    /opt/local/ruby/1.9.3-p484/lib/ruby/gems/1.9.1/gems/bundler-1.6.3/lib/bundler.rb:235:in `block in with_clean_env'
    /opt/local/ruby/1.9.3-p484/lib/ruby/gems/1.9.1/gems/bundler-1.6.3/lib/bundler.rb:222:in `with_original_env'
    /opt/local/ruby/1.9.3-p484/lib/ruby/gems/1.9.1/gems/bundler-1.6.3/lib/bundler.rb:228:in `with_clean_env'
    /var/snap-ci/repo/test/mini_test_helper.rb:23:in `run_command'
    /var/snap-ci/repo/test/packages/ruby_test.rb:11:in `block in test_rubies_are_installed'
    /var/snap-ci/repo/test/packages/ruby_test.rb:7:in `each'
    /var/snap-ci/repo/test/packages/ruby_test.rb:7:in `test_rubies_are_installed'
!}
  end
end
