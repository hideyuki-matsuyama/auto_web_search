require 'selenium-webdriver'
require 'clipboard'
require 'uri'

# 既存の Chrome に接続
options = Selenium::WebDriver::Chrome::Options.new
options.debugger_address = 'localhost:9222'
options.add_argument('--user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64)')
driver = Selenium::WebDriver.for(:chrome, options: options)

# ページロード待機
driver.manage.timeouts.implicit_wait = 1.5

# 企業名リストのファイルパス
input_file_path = '企業名リスト.txt'
output_file_path = '検索結果.txt'

# 企業名リストを読み込む
lines = File.readlines(input_file_path).map(&:strip)

File.open(output_file_path, 'a') do |file|
  lines.each_with_index do |line, idx|
    # 検索
    search_url = 'https://duckduckgo.com?' + URI.encode_www_form([['t', 'h_'], ['q', "\"#{line}\" 企業ページ"], ['ia', 'web']])
    # search_url = 'https://duckduckgo.com?' + URI.encode_www_form([['t', 'h_'], ['q', "#{line} 企業ページ"], ['ia', 'web']])
    driver.navigate.to search_url

    # 検索結果のURL取得
    # SERP に法人格が含まれないことがあるため機械的に最初を見る
    first_result = driver.find_elements(xpath: '//h2/a')[0]
    result = first_result ? first_result.attribute('href') : '🔥'

    # ウェイトをランダムに設定
    sleep(rand 3..6) if idx % 10 == 0

    file.puts "#{line}\t#{result}"
  end
end

puts "検索結果が #{output_file_path} に保存されました。"
