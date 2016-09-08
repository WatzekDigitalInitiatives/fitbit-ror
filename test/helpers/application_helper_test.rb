require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase

  def setup
    @base_title = "WalkLC"
  end

  test "full_title should work" do
    assert_equal "#{@base_title}", full_title
    assert_equal "Test | #{@base_title}", full_title("Test")
  end

end
