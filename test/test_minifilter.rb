require 'helper'

class TestMinifilter < Test::Unit::TestCase
  should "MiniTest::output == MiniFilter" do
    assert_equal MiniTest::Unit.output ,MiniFilter
  end
end
