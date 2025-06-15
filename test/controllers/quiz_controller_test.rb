require "test_helper"

class QuizControllerTest < ActionDispatch::IntegrationTest
  setup do
    @question = questions(:one)
  end

  test "should get index" do
    get quiz_index_url
    assert_response :success
  end

  test "should get show with question" do
    get quiz_url(@question)
    assert_response :success
  end

  test "should get result" do
    get result_quiz_index_url
    assert_response :success
  end
end
