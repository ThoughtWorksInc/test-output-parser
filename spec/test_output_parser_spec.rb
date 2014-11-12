require 'spec_helper'

describe TestOutputParser do
  it 'should give the summary of specs for rspec' do
    actual = TestOutputParser.count(File.read("spec/fixtures/sample-failed-rspec-output.txt"))
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
    expect(actual).to eq(expected)
  end

  it 'should give the summary of specs for test unit' do
    actual = TestOutputParser.count(File.read("spec/fixtures/sample-failed-test-unit-output.txt"))
    expected = {
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
!
    }
    expect(actual).to eq(expected)
  end

  it 'should give the summary of specs for junit' do
    actual = TestOutputParser.count(File.read("spec/fixtures/sample-gradle-output.txt"))
    expected = {
      :total => 47,
      :failed => 1,
      :failures => "Running test: test shouldAddBookToDBIfNotInSystem(com.thoughtworks.twu.controller.AddBookControllerTest)\n\n" +
        "com.thoughtworks.twu.controller.AddBookControllerTest > shouldAddBookToDBIfNotInSystem FAILED\n" +
        "    java.lang.AssertionError at AddBookControllerTest.java:28"
    }
    expect(actual).to eq(expected)
  end

  it 'should add up the summaries when there are specs for multiple frameworks' do
    actual = TestOutputParser.count(File.read("spec/fixtures/sample-failed-test-unit-output.txt") + "\n" + File.read("spec/fixtures/sample-failed-rspec-output.txt"))
    expected = {
      :total => 111,
      :failed => 2,
      :failures => %Q!  1) PostsController GET index assigns all posts as @posts
     Failure/Error: assert false
     MiniTest::Assertion:
       Failed assertion, no message given.
     # (eval):2:in `assert'
     # ./spec/controllers/posts_controller_spec.rb:39:in `block (3 levels) in <top (required)>'


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
!,
      :errors => 1
    }
    expect(actual).to eq(expected)
  end
end
