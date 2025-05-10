def generate_company_name
  prefixes = ["グローバル", "未来", "先進", "ハイテク", "エコ", "ダイナミック", "クリエイティブ"]
  suffixes = ["ソリューション", "テクノロジー", "システム", "サービス", "イノベーション", "ネットワーク", "マーケティング"]

  "#{prefixes.sample} #{suffixes.sample}株式会社"
end

# 出力ファイルを指定
output_file = "架空の会社名一覧.txt"

# 2000件の会社名を生成してファイルに保存
File.open(output_file, 'w') do |file|
  2000.times do |i|
    file.puts generate_company_name
  end
end

puts "架空の会社名を #{output_file} に保存しました！"
