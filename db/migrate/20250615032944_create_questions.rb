class CreateQuestions < ActiveRecord::Migration[8.0]
  def change
    create_table :questions do |t|
      t.text :question
      t.string :option_a
      t.string :option_b
      t.string :option_c
      t.string :option_d
      t.string :correct_answers
      t.text :explanation
      t.string :category
      t.string :difficulty

      t.timestamps
    end
  end
end
