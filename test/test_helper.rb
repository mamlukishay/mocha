unless defined?(STANDARD_OBJECT_PUBLIC_INSTANCE_METHODS)
  STANDARD_OBJECT_PUBLIC_INSTANCE_METHODS = Object.instance_methods + Object.private_instance_methods
end

$:.unshift File.expand_path(File.join(File.dirname(__FILE__), "..", "lib"))
$:.unshift File.expand_path(File.join(File.dirname(__FILE__)))
$:.unshift File.expand_path(File.join(File.dirname(__FILE__), 'unit'))
$:.unshift File.expand_path(File.join(File.dirname(__FILE__), 'unit', 'parameter_matchers'))
$:.unshift File.expand_path(File.join(File.dirname(__FILE__), 'acceptance'))

# require 'test/unit'
require 'minitest/autorun'
module Test
  module Unit
    class TestCase < ::MiniTest::Test
      def assert_nothing_raised(exception = StandardError)
        yield
      rescue exception => e
        flunk "Unexpected exception raised: #{e}"
      end

      alias_method :assert_not_nil, :refute_nil
      alias_method :assert_raise, :assert_raises
      alias_method :assert_not_same, :refute_same
      alias_method :assert_no_match, :refute_match
    end
  end
end
