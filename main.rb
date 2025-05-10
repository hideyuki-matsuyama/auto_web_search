require 'selenium-webdriver'
require 'clipboard'

# 既存の Chrome に接続
options = Selenium::WebDriver::Chrome::Options.new
options.debugger_address = 'localhost:9222'
options.add_argument('--user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64)')
driver = Selenium::WebDriver.for(:chrome, options: options)

# 企業名リストのファイルパス
input_file_path = '企業名リスト.txt'
output_file_path = '検索結果.txt'

# 企業名リストを読み込む
lines = File.readlines(input_file_path).map(&:strip)

lines.each_slice(25) do |sub_lines|
  results = sub_lines.map do |line|
    # ロボット認定対策
    sleep rand 5..10

    # Googleで検索
    driver.navigate.to('https://www.google.com')

    # sleep 1  # ページロード待機
    driver.manage.timeouts.implicit_wait = 10

    search_box = driver.find_element(name: 'q')
    search_box.send_keys("#{line} 企業ページ")
    search_box.submit

    # sleep 1  # ページロード待機
    driver.manage.timeouts.implicit_wait = 10

    # 検索結果のURL取得（最初の結果）
    # 法人格が含まれないことがあるため機械的に最初を見る
    first_result = driver.find_elements(xpath: '//h3[1]/parent::a')[0]
    result = first_result ? first_result.attribute('href') : '🔥'

    "#{line}\t#{result}"
  end

  # 検索結果を保存するファイルを開く
  File.open(output_file_path, 'a') do |file|
    results.each do |result|
      # 別ファイルに企業名と検索結果URLを保存
      file.puts result
    end
  end

  # ロボット認定対策
  # sleep rand 10..15
end

puts "検索結果が #{output_file_path} に保存されました。"
