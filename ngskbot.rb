#!/usr/local/bin/ruby
# -*- coding: utf-8 -*-

require 'pp'
require 'user_stream'
require 'thread'

UserStream.configure do |config|
  config.consumer_key = gets.chomp
  config.consumer_secret = gets.chomp
  config.oauth_token = gets.chomp
  config.oauth_token_secret = gets.chomp
end

bot_name = gets.chomp
user_name = []

while true
  tmp = gets.chomp
  break if tmp.empty?
  user_name.push tmp
end

client = UserStream.client

q = Queue.new

user_stream = Thread.new do
  client.user do |status|
    if status.has_key? "text"
      q.push(status)
    end
  end
end

user_stream.run

while true
  pp q.pop
end
