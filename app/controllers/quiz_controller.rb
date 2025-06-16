class QuizController < ApplicationController
  before_action :set_question, only: [ :show ]

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
    answer_params = params.permit(:question_number, :category, :difficulty, answers: [])
    selected_answers = answer_params[:answers] || []
    question_number = answer_params[:question_number]&.to_i || 1

    # 現在の問題を取得
    question = filtered_questions.offset(question_number - 1).first

    # 正誤判定
    is_correct = question.is_correct?(selected_answers)

    # セッションに結果を保存（結果表示用のみ）
    session[:quiz_results] ||= []
    session[:quiz_results] << {
      question_id: question.id,
      selected_answers: selected_answers,
      correct: is_correct
    }

    # フィードバック情報をURLパラメータで渡す
    feedback_params = {
      question_number: question_number,
      selected_answers: selected_answers.join(","),
      correct: is_correct ? "1" : "0",
      category: answer_params[:category],
      difficulty: answer_params[:difficulty]
    }.compact

    respond_to do |format|
      format.html { redirect_to feedback_quiz_path(question_number, feedback_params) }
      format.turbo_stream { redirect_to feedback_quiz_path(question_number, feedback_params) }
    end
  end

  def feedback
    # URLパラメータから情報を取得
    @question_number = params[:question_number]&.to_i || params[:id].to_i
    @selected_answers = params[:selected_answers]&.split(",") || []
    @is_correct = params[:correct] == "1"

    # フィルター条件を設定
    params[:category] = params[:category] if params[:category].present?
    params[:difficulty] = params[:difficulty] if params[:difficulty].present?

    # 問題を取得
    @question = filtered_questions.offset(@question_number - 1).first

    unless @question
      redirect_to quiz_index_path, alert: "問題が見つかりませんでした"
      return
    end

    @total_questions = filtered_questions.count

    # 次の問題の情報
    @next_question_number = @question_number + 1
    @has_next_question = @next_question_number <= @total_questions

    # フィルターパラメータ
    @filter_params = {
      category: params[:category],
      difficulty: params[:difficulty]
    }.compact
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

  # デバッグ用：セッションクリア
  def clear_session
    session.clear
    redirect_to quiz_index_path, notice: "セッションをクリアしました"
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
