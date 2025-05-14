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
input_file_path = '検索キーワード一覧.txt'
output_file_path = '検索結果_duckduckgo.txt'

# 企業名リストを読み込む
lines = File.readlines(input_file_path)

EXCLUDE_SITES = %w(
  beautifyjp.net
  beauty-job.biz
  beauty.biglobe.ne.jp
  beauty.hotpepper.jp
  beauty.rakuten.co.jp
  biyousitu.yu-nagi.com
  blogtag.ameba.jp
  hairbook.jp
  hairlog.jp
  hermo-style.com
  kireistyle-woman.com
  map.yahoo.co.jp
  minimodel.jp
  page.line.me
  zouri.jp
  web.fc2.com
  stylelog.tokyo
  www.ameba.jp
  www.beauty-park.jp
  www.ekiten.jp
  www.instagram.com
  www.navitime.co.jp
  www.yelp.com
).freeze

lines.each_with_index do |line, idx|
  line.strip!
  line.gsub!(/\u200B/, '')
  line.gsub!("\t", ' ')
  next if line.empty?

  search_keyword = "#{line} #{EXCLUDE_SITES.map { |w| "-#{w}"}.join(' ')}"

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
  result = "\tちょりぽん\t"
  result = if earth_link
              earth_link.attribute('href')
            else
              first_result = driver.find_elements(xpath: '//h2/a')[0] # DuckDuckGo
              # first_result = driver.find_elements(xpath: '//h3[1]/parent::a')[0]  # Google
              first_result.attribute('href') unless first_result.nil?
            end || '該当URLなし'

  # ウェイトを入れる
  # sleep(rand 3)
  # sleep(rand 30..60) if idx % 10 == 0

  line += "\t#{result}"

  File.open(output_file_path, 'a') do |file|
    file.puts line
  end
end

puts "検索結果が #{output_file_path} に保存されました。"
