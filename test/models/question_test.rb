require "test_helper"

class QuestionTest < ActiveSupport::TestCase
  test "should be valid with valid attributes" do
    question = Question.new(
      question: "テスト問題",
      option_a: "選択肢A",
      option_b: "選択肢B",
      correct_answers: "A",
      category: "テストカテゴリー"
    )
    assert question.valid?
  end

  test "should require question" do
    question = Question.new
    assert_not question.valid?
    assert_includes question.errors[:question], "can't be blank"
  end

  test "should return correct answer array" do
    question = questions(:two)
    assert_equal [ "A", "C" ], question.correct_answer_array
  end

  test "should check if answer is correct" do
    question = questions(:one)
    assert question.is_correct?([ "A" ])
    assert_not question.is_correct?([ "B" ])
  end

  test "should check multiple correct answers" do
    question = questions(:two)
    assert question.is_correct?([ "A", "C" ])
    assert question.is_correct?([ "C", "A" ])
    assert_not question.is_correct?([ "A" ])
    assert_not question.is_correct?([ "A", "B" ])
  end
end
