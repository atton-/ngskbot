#!/usr/local/bin/ruby
# -*- coding: utf-8 -*-

# メッセージをどう処理するのか決めるクラス
# botの名前とかoriginal_userの名前を入れておく

class Message

  def initialize bot_name,original_name
    @bot_name = bot_name
    @original_name = original_name
  end

  def test text
    has_usrname? text
  end

  def formatCheck tweet
    # フォーマットをチェックする
    # 返り値と処理
    # 0       追加
    # -1      エラー : 改行が含まれている
    # -2      エラー : フォーマットが違う
    # 1以上   数字の分だけ返信
    
    if has_usrname? tweet.text
      
    end

  end

  private

  def has_usrname? text
    # original の username が含まれているかどうか
    @original_name.each do |name|
      return true if text.include? "@#{name}"
    end
    false
  end

end

bot = "ngskbot"
users =["hamilton___","daijoubjanai","daijoubujanee"]

puts Message.new(bot,users).test "hoge"
puts Message.new(bot,users).test "@hamilton___"
puts Message.new(bot,users).test "@daijoubujanee"
