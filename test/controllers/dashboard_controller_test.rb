require 'test_helper'

class DashboardControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
  end

  test 'should get index' do
    get root_url
    assert_response :success
  end

  private

  def sign_in(user)
    post user_session_path, params: {
      user: { email: user.email, password: 'password123' }
    }
  end
end
