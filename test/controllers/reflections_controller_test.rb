require "test_helper"

class ReflectionsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get reflections_create_url
    assert_response :success
  end

  test "should get destroy" do
    get reflections_destroy_url
    assert_response :success
  end
end
