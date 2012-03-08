#!/usr/local/bin/ruby
# -*- coding: utf-8 -*-

require 'pp'
require 'thread'
require 'user_stream'
require 'twitter'
require './message_check.rb'

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

# UserStreamとRESTに認証
UserStream.configure do |config|
  config.consumer_key = consumer_key
  config.consumer_secret = consumer_secret
  config.oauth_token = oauth_token
  config.oauth_token_secret = oauth_token_secret
end
Twitter.configure do |config|
  config.consumer_key = consumer_key
  config.consumer_secret = consumer_secret
  config.oauth_token = oauth_token
  config.oauth_token_secret = oauth_token_secret
end

# チェック用クラス生成
check = Message_check.new bot_name,user_name

# UserStream 作成
client = UserStream.client

# Thread 間通信用キュー作成
q = Queue.new

#UserStreamを受信するスレッドを作成
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
  pp check.format_check q.pop

  # error が出たら落ちちゃうので、begin-rescue-end でゴリ押し
  begin
    Twitter.update("test now")
  rescue
  end
end
