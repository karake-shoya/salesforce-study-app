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

  test "should get show with question_number parameter" do
    get quiz_url(@question, question_number: 1)
    assert_response :success
  end

  test "should post answer and redirect to feedback" do
    post answer_quiz_url(@question), params: {
      question_number: 1,
      category: "テストカテゴリー",
      difficulty: "初級",
      answers: [ "A" ]
    }
    assert_response :redirect
    assert_redirected_to feedback_quiz_url(@question)
  end

  test "should post answer with multiple selections" do
    post answer_quiz_url(@question), params: {
      question_number: 1,
      category: "",
      difficulty: "",
      answers: [ "A", "C" ]
    }
    assert_response :redirect
    # リダイレクト先のパスパターンをチェック（IDは動的なので）
    assert_match %r{/quiz/\d+/feedback}, response.location
  end

  test "should get feedback with valid session data" do
    # まずanswerアクションでセッションを設定
    post answer_quiz_url(@question), params: {
      question_number: 1,
      category: "テストカテゴリー",
      difficulty: "初級",
      answers: [ "A" ]
    }

    # feedbackページにアクセス
    get feedback_quiz_url(@question)
    assert_response :success
  end

  test "should redirect to index when feedback session data is missing" do
    get feedback_quiz_url(@question)
    assert_response :redirect
    assert_redirected_to quiz_index_url
    assert_equal "フィードバック情報が見つかりませんでした", flash[:alert]
  end

  test "should get result" do
    get result_quiz_index_url
    assert_response :success
  end

  test "should clear sessions on result" do
    # answerアクションでセッションを設定
    post answer_quiz_url(@question), params: {
      question_number: 1,
      category: "",
      difficulty: "",
      answers: [ "A" ]
    }

    # resultページにアクセス（セッションクリア）
    get result_quiz_index_url
    assert_response :success

    # 再度feedbackにアクセスしてセッションがクリアされていることを確認
    get feedback_quiz_url(@question)
    assert_response :redirect
    assert_redirected_to quiz_index_url
  end
end
