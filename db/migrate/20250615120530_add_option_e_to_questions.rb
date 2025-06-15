class AddOptionEToQuestions < ActiveRecord::Migration[8.0]
  def change
    add_column :questions, :option_e, :string
  end
end
