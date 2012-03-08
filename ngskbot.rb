#!/usr/local/bin/ruby
# -*- coding: utf-8 -*-

# デバッグするかどうか。
# trueならtwitterにポストせずに標準出力に出すだけ
DEBUG_FLG = false

require 'pp'
require 'thread'
require 'user_stream'
require 'twitter'
require './message_check.rb'
require './tweet.rb'

# 標準入力からトークン、botname,username(複数可)を取得
consumer_key = gets.chomp
consumer_secret = gets.chomp
oauth_token = gets.chomp
oauth_token_secret = gets.chomp
bot_name = gets.chomp
user_name = []
while true
  tmp = gets.chomp
  break if tmp.empty?
  user_name.push tmp
end

# UserStreamに認証
UserStream.configure do |config|
  config.consumer_key = consumer_key
  config.consumer_secret = consumer_secret
  config.oauth_token = oauth_token
  config.oauth_token_secret = oauth_token_secret
end
# REST用クラス作成
twitter = Tweet.new consumer_key,consumer_secret,oauth_token,oauth_token_secret,DEBUG_FLG

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
  # キューが空ならスレッドは停止するので、無限ループしてても大丈夫

  # キューからツイートを取ってくる
  tweet = q.pop

  # format_check に投げて処理を判断
  num = check.format_check tweet

  case num
  when -1
    # add
    puts "add"
  when -2
    # multi line
    puts "multi line"
  when -3 
    # irigal format
    puts "irigal format"
  else
    # no-reply or single reply or multi reply
    num.times do
      puts "reply"
    end
  end
end
