class Question < ApplicationRecord
  validates :question, presence: true
  validates :option_a, :option_b, presence: true
  validates :correct_answers, presence: true
  validates :category, presence: true

  def options
    [ option_a, option_b, option_c, option_d, option_e ].compact
  end

  def correct_answer_array
    correct_answers.split(",").map(&:strip)
  end

  def is_correct?(selected_answers)
    selected_answers.sort == correct_answer_array.sort
  end

  def self.by_category(category)
    where(category: category) if category.present?
  end

  def self.by_difficulty(difficulty)
    where(difficulty: difficulty) if difficulty.present?
  end
end
