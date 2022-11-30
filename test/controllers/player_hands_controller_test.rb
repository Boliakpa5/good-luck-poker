require "test_helper"

class PlayerHandsControllerTest < ActionDispatch::IntegrationTest
  test "should get call_hand" do
    get player_hands_call_hand_url
    assert_response :success
  end

  test "should get raise_hand" do
    get player_hands_raise_hand_url
    assert_response :success
  end

  test "should get fold_hand" do
    get player_hands_fold_hand_url
    assert_response :success
  end
end
