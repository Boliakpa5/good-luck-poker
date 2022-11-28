require "test_helper"

class TableHandsControllerTest < ActionDispatch::IntegrationTest
  test "should get start" do
    get table_hands_start_url
    assert_response :success
  end
end
