#!/usr/local/bin/ruby
# -*- coding: utf-8 -*-
# ツイート関連をまとめるクラス

require 'twitter'

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
end
