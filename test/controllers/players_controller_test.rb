require "test_helper"

class PlayersControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get players_create_url
    assert_response :success
  end

  test "should get leave" do
    get players_leave_url
    assert_response :success
  end
end
