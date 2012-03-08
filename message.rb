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
     count_botname text
  end

  def formatCheck tweet
    # フォーマットをチェックする
    # 返り値と処理
    # 0       追加
    # -1      エラー : クライアントが夜フクロウじゃない
    # -2      エラー : 改行が含まれている
    # -3      エラー : フォーマットが違う
    # 1以上   数字の分だけ返信


    # original_usernameが含まれていない場合
    # 通常返信なので、bot_nameが含まれている数を返す
    if !has_username? tweet.text do
      return count_botname tweet.text
    end

    end

  end

  private

  def has_username? text
    # original の username が含まれているかどうか
    @original_name.each do |name|
      return true if text.include? "@#{name}"
    end
    false
  end

  def count_botname text
    # bot_name の数を数える
    # bot_name が無くなるまで置換を繰り返し、繰り返しの数を個数として返す
    i = 0
    while text != text.sub("@#{@bot_name}","")
      text.sub!("@#{@bot_name}","")
      i += 1
    end
    i
  end

end

bot = "ngskbot"
users =["hamilton___","daijoubjanai","daijoubujanee"]

puts Message.new(bot,users).test "hoge"
puts Message.new(bot,users).test "@hamilton___"
puts Message.new(bot,users).test "@daijoubujanee"
puts Message.new(bot,users).test "@ngskbot"
puts Message.new(bot,users).test "@ngskbot@ngskbot@ngskbot@ngskbot"
