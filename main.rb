require 'selenium-webdriver'
require 'clipboard'
require 'uri'
require 'pry'

# 既存の Chrome に接続
options = Selenium::WebDriver::Chrome::Options.new
options.debugger_address = 'localhost:9222'
driver = Selenium::WebDriver.for(:chrome, options: options)

# ページロード待機
driver.manage.timeouts.implicit_wait = 3

# 企業名リストのファイルパス
input_file_path = '企業名リスト.txt'
output_file_path = '検索結果_duckduckgo.txt'

# 企業名リストを読み込む
lines = File.readlines(input_file_path)

EXCLUDE_WORDS = %w(
  ホットペッパー
  化粧品検定
  検索結果
  一覧
  tiktok
  kirei
  instagram
  esthete
  event
  panolabollc
  ekiten
  indeed
  口コミ
  体験
  体験談
  体験レポート
  体験記
  体験者
  yahoo
  iyasheep
  求人
  linkedin
  おすすめ
  beauty-park
  はてな
  hermo-style
  hairbook.jp
  burari.net
  facebook.com
  biew.jp
  varie-group.jp
  salontime
  esthesearch
  rakuten
  楽天
  gekiyasu-biyouin.com
  hairlog.jp
  pilotfree.com
  kakaku.guide

).freeze

lines.each_with_index do |line, idx|
  line.strip!
  line.gsub!(/\u200B/, '')
  line.gsub!("\t", ' ')
  next if line.empty?

  search_keyword = "#{line} #{EXCLUDE_WORDS.map { |w| "-#{w}"}.join(' ')}"

  user_agent = if rand(0..5) % 2 == 0
    "Mozilla/5.0 (Windows NT 10.#{rand 9}; Win64; x64)"
  else
    tmp_version = "#{rand 530..537}.#{rand 30..36}"
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/#{tmp_version} (KHTML, like Gecko) Chrome/136.0.0.0 Safari/#{tmp_version}"
  end
  pp user_agent

  driver.execute_cdp('Network.setUserAgentOverride', userAgent: user_agent)
  driver.navigate.to('https://www.duckduckgo.com')
  search_box = driver.find_element(name: 'q')
  search_box.send_keys search_keyword
  search_box.submit

  earth_link = driver.find_elements(xpath: "//div[contains(text(), 'ウェブサイト')]/parent::a")[0]
  result = if earth_link
              earth_link.attribute('href')
            else
              first_result = driver.find_elements(xpath: '//h2/a')[0] # DuckDuckGo
              # first_result = driver.find_elements(xpath: '//h3[1]/parent::a')[0]  # Google
              first_result.attribute('href') unless first_result.nil?
            end || "\t該当URLなし"

  # ウェイトを入れる
  # sleep(rand 3)
  # sleep(rand 30..60) if idx % 10 == 0

  line += "\t#{result}"

  File.open(output_file_path, 'a') do |file|
    file.puts line
  end
end

puts "検索結果が #{output_file_path} に保存されました。"
