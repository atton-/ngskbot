#!/usr/local/bin/ruby
# -*- coding: utf-8 -*-

# デバッグするかどうか。
# trueならtwitterにポストせずに標準出力に出すだけ
DEBUG_FLG = true

# ファイルのパス
FILES_PATH = gets.chomp

dir = File.dirname File.expand_path(__FILE__)
require 'pp'
require 'user_stream'
require "#{dir}/message_check.rb"
require "#{dir}/tweet.rb"

# 標準入力からトークン、botname,username(複数可)を取得
tokens = {
  "consumer_key" => gets.chomp,
  "consumer_secret" => gets.chomp,
  "oauth_token" => gets.chomp,
  "oauth_token_secret" => gets.chomp
}
bot_name = gets.chomp
user_name = []
while true
  tmp = gets.chomp
  break if tmp.empty?
  user_name.push tmp
end

# UserStreamに認証
UserStream.configure do |config|
  config.consumer_key = tokens["consumer_key"]
  config.consumer_secret = tokens["consumer_secret"]
  config.oauth_token = tokens["oauth_token"]
  config.oauth_token_secret = tokens["oauth_token_secret"]
end
# ツイート関連用クラス作成
twitter = Tweet.new tokens,FILES_PATH,DEBUG_FLG

# チェック用クラス生成
check = Message_check.new bot_name,user_name

# UserStream 作成
client = UserStream.client

# UserStream で tweet を受信
client.user do |status|
  if status.has_key? "text"
    # tweetが流れてきたらcheckしてreplyを返す
    twitter.tweet_reply(status,check.format_check(status))
  end
end

# 再起動
# このファイルと同じディレクトリに起動用の run_ngskbot.rb がある前提。
exec "ruby #{File.dirname File.expand_path(__FILE__)}/run_ngskbot.rb"
