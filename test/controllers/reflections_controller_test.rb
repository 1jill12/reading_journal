require 'test_helper'

class ReflectionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @book = books(:one)
    sign_in @user
  end

  test 'creates a reflection for a book' do
    assert_difference('Reflection.count') do
      post book_reflections_path(@book), params: { reflection: { content: 'Great chapter!' } }
    end
    assert_redirected_to book_url(@book)
  end

  test 'destroys a reflection' do
    reflection = @book.reflections.create!(content: 'To be deleted')
    assert_difference('Reflection.count', -1) do
      delete book_reflection_path(@book, reflection)
    end
    assert_redirected_to book_url(@book)
  end

  private

  def sign_in(user)
    post user_session_path, params: {
      user: { email: user.email, password: 'password123' }
    }
  end
end
