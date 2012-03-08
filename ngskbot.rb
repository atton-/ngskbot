#!/usr/local/bin/ruby
# -*- coding: utf-8 -*-

require 'pp'
require 'user_stream'

UserStream.configure do |config|
  config.consumer_key = gets.chomp
  config.consumer_secret = gets.chomp
  config.oauth_token = gets.chomp
  config.oauth_token_secret = gets.chomp
end

bot_name = gets.chomp
uesr_name = []

while true
  tmp = gets.chomp
  break if tmp.empty?
  user_name.push tmp
end

client = UserStream.client
client.user do |status|
  if status.has_key? "text"
    pp status.text
  end
end
