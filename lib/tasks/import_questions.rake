require "csv"

namespace :questions do
  desc "Import questions from CSV file"
  task import: :environment do
    csv_file = ENV["CSV_FILE"] || "db/questions.csv"

    unless File.exist?(csv_file)
      puts "❌ CSVファイルが見つかりません: #{csv_file}"
      puts "使用方法: rails questions:import CSV_FILE=path/to/your/file.csv"
      exit 1
    end

    imported_count = 0

    CSV.foreach(csv_file, headers: true, encoding: "UTF-8", liberal_parsing: true, quote_char: '"') do |row|
      question = Question.find_or_initialize_by(id: row["id"])

      question.assign_attributes(
        question: row["question"],
        option_a: row["option_a"],
        option_b: row["option_b"],
        option_c: row["option_c"],
        option_d: row["option_d"],
        correct_answers: row["correct_answers"],
        explanation: row["explanation"],
        category: row["category"],
        difficulty: row["difficulty"]
      )

      if question.save
        imported_count += 1
        puts "✅ 問題 #{question.id}: #{question.question[0..50]}..."
      else
        puts "❌ エラー: #{question.errors.full_messages.join(', ')}"
      end
    end

    puts "\n🎉 #{imported_count}問の問題をインポートしました！"
  end
end
