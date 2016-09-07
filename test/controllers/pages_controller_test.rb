require 'test_helper'

class PagesControllerTest < ActionController::TestCase

  def setup
    @base_title = "WalkLC"
  end

  test "shuld get home" do
    get :home
    assert_response :success
    assert_select "title", "Home | #{@base_title}"
  end

  test "shuld get about" do
    get :about
    assert_response :success
    assert_select "title", "About | #{@base_title}"
  end

end
