#!/usr/local/bin/ruby
# -*- coding: utf-8 -*-
# ツイート関連をまとめるクラス

require 'twitter'
require 'pp'
require './io.rb'

class Tweet

  def initialize consumer_key,consumer_secret,oauth_token,oauth_token_secret,debug = true
    # initialize で認証。
    # デバッグフラグもここで付ける。念のためデフォルトはtrue
    Twitter.configure do |config|
      config.consumer_key = consumer_key
      config.consumer_secret = consumer_secret
      config.oauth_token = oauth_token
      config.oauth_token_secret = oauth_token_secret
    end
    @debug = debug
  end
  
  def post message,options={}
    # ポストする
    
    if @debug
      # デバッグモード時。内容の確認のみ。
      puts "----- (debug mode : check ) ------"
      puts "ポスト予定の内容"
      puts message
      pp options
      puts "---- (debug mode : check end ) ----"
      puts
    else
      # ポストする
      # errorが起きると落ちちゃうので、begin-rescue-endでゴリ押し。
      # contents duplicate 対策。
      begin
        Twitter.update message,options
      rescue
      end
    end
  end
end
