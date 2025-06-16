ActiveRecord::Schema[8.0].define(version: 2025_06_15_120530) do
  create_table "questions", force: :cascade do |t|
    t.text "question"
    t.string "option_a"
    t.string "option_b"
    t.string "option_c"
    t.string "option_d"
    t.string "correct_answers"
    t.text "explanation"
    t.string "category"
    t.string "difficulty"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "option_e"
  end
end
