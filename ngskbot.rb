#!/usr/local/bin/ruby
# -*- coding: utf-8 -*-

# デバッグするかどうか。
# trueならtwitterにポストせずに標準出力に出すだけ
DEBUG_FLG = true

# ファイルのパス
FILES_PATH = "./files_ngskbot"

require 'pp'
require 'thread'
require 'user_stream'
require './message_check.rb'
require './tweet.rb'

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

# Thread 間通信用キュー作成
q = Queue.new

# UserStreamを受信するスレッドを作成
user_stream = Thread.new do
  client.user do |status|
    if status.has_key? "text"
      #textが含まれていたらとりあえずキューにpushする
      q.push(status)
    end
  end
end

# スレッドを走らせる
user_stream.run

while true
  # main loop
  # キューが空ならスレッドは停止するので、無限ループしてても大丈夫

  # キューからツイートを取ってくる
  tweet = q.pop

  # format_check に投げて処理を判断して、リプライを送る
  twitter.tweet_reply(tweet,check.format_check(tweet))
end
