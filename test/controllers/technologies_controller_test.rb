require "test_helper"

class TechnologiesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get technologies_index_url
    assert_response :success
  end

  test "should get show" do
    get technologies_show_url
    assert_response :success
  end

  test "should get create" do
    get technologies_create_url
    assert_response :success
  end

  test "should get update" do
    get technologies_update_url
    assert_response :success
  end

  test "should get destroy" do
    get technologies_destroy_url
    assert_response :success
  end
end
