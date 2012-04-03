# -*- coding: utf-8 -*-

# 定期post用のngskbot。
# cron で時刻ごとにまわす。
# ngskbot本体と同じ設定をリダイレクションされる予定。

# デバッグするかどうか
# trueならtwitterにポストせずに標準出力に出すだけ
DEBUG_FLG = true

# 各種ファイルのパス
FILES_PATH = gets.chomp

dir = File.dirname File.expand_path(__FILE__)
require "#{dir}/tweet.rb"

tokens = {
  "consumer_key" => gets.chomp,
  "consumer_secret" => gets.chomp,
  "oauth_token" => gets.chomp,
  "oauth_token_secret" => gets.chomp
}

Tweet.new(tokens,FILES_PATH,DEBUG_FLG).random_post
