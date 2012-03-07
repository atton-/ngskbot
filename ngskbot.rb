#!/usr/local/bin/ruby
# -*- coding: utf-8 -*-

BOT_NAME = "ngskbot"

UserStream.configure do |config|
  config.consumer_key = gets.chomp
  config.consumer_secret = gets.chomp
  config.oauth_token = gets.chomp
  config.oauth_token_secret = gets.chomp
end

client = UserStream.client
client.user do |status|
  if status.has_key? "text"
    pp status.text
  end
end
