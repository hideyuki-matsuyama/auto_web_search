# 🚧WIP

検索エンジンを利用して、キーワードに該当する WEB サイトの URL を収集するプログラムです。

# Ruby でのアプローチ

- Chrome をデバッグモードで起動
- `selenium` で画面操作を行う

# Python でのアプローチ

- AI エージェントがウェブブラウザを操作できるようにするためのライブラリ [Browser Use](https://github.com/browser-use/browser-use) を利用する

# メモ

```sh
gem install selenium-webdriver
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --remote-debugging-port=9222 --disable-gcm --user-data-dir=/tmp/chrome_dev
time ruby main.rb
```

========================================================

```sh
brew install pipx
python3 -m venv myenv
source myenv/bin/activate
python3 -m ensurepip --default-pip
pip install browser_use
pip install --upgrade pip
pip install browser-automation
pip install playwright
pip install selenium
playwright install chromium --with-deps --no-shell

time ruby run_search.rb
```
