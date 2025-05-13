require 'open3'

File.open("keywords.txt", "r") do |file|
  file.each_line do |keyword|
    keyword.strip!

    # Browser Use を使うPythonスクリプトを実行
    output, _error, _status = Open3.capture3("python3 search_agent.py '#{keyword}'")

    # ホットペッパーのURLを除外
    filtered_urls = output.split("\n").reject { |url| url.include?("hotpepper.jp") }

    # 結果をテキストファイルに保存
    File.open("results.txt", "a") do |result_file|
      result_file.puts(filtered_urls)
    end
  end
end

puts "検索処理が完了しました"
