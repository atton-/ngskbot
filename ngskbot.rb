#!/usr/local/bin/ruby
# -*- coding: utf-8 -*-

require 'pp'
require 'user_stream'
require 'thread'
require './message_check.rb'

UserStream.configure do |config|
  config.consumer_key = gets.chomp
  config.consumer_secret = gets.chomp
  config.oauth_token = gets.chomp
  config.oauth_token_secret = gets.chomp
end

bot_name = gets.chomp
user_name = []
check = Message_check.new bot_name,user_name


while true
  tmp = gets.chomp
  break if tmp.empty?
  user_name.push tmp
end

client = UserStream.client

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

user_stream.run

while true
  #キューが空ならスレッドは停止する
  pp check.format_check q.pop
end
