class QuizController < ApplicationController
  before_action :set_question, only: [ :show, :answer ]

  def index
    @categories = Question.distinct.pluck(:category).compact
    @difficulties = Question.distinct.pluck(:difficulty).compact
    @total_questions = Question.count
  end

  def show
    @question_number = params[:question_number]&.to_i || 1
    @total_questions = filtered_questions.count

    if @question_number > @total_questions
      redirect_to result_quiz_index_path
      return
    end

    @question = filtered_questions.offset(@question_number - 1).first

    unless @question
      redirect_to quiz_index_path, alert: "問題が見つかりませんでした"
      nil
    end
  end

  def answer
    selected_answers = params[:answers] || []
    is_correct = @question.is_correct?(selected_answers)

    # セッションに結果を保存
    session[:quiz_results] ||= []
    session[:quiz_results] << {
      question_id: @question.id,
      selected_answers: selected_answers,
      correct: is_correct
    }

    question_number = params[:question_number]&.to_i || 1
    next_question = question_number + 1

    if next_question > filtered_questions.count
      redirect_to result_quiz_index_path
    else
      redirect_to quiz_path(id: next_question, **filter_params)
    end
  end

  def result
    @results = session[:quiz_results] || []
    @total_questions = @results.count
    @correct_count = @results.count { |r| r["correct"] }
    @score_percentage = @total_questions > 0 ? (@correct_count.to_f / @total_questions * 100).round(1) : 0

    # 結果の詳細を取得
    @detailed_results = @results.map do |result|
      question = Question.find(result["question_id"])
      {
        question: question,
        selected_answers: result["selected_answers"],
        correct: result["correct"]
      }
    end

    # セッションをクリア
    session[:quiz_results] = nil
  end

  private

  def set_question
    @question = Question.find(params[:id]) if params[:id].present?
  end

  def filtered_questions
    @filtered_questions ||= begin
      questions = Question.all
      questions = questions.by_category(params[:category]) if params[:category].present?
      questions = questions.by_difficulty(params[:difficulty]) if params[:difficulty].present?
      questions
    end
  end

  def filter_params
    params.permit(:category, :difficulty, :question_number)
  end
end
