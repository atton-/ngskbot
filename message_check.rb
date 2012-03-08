#!/usr/local/bin/ruby
# -*- coding: utf-8 -*-

# メッセージをどう処理するのか決めるクラス
# botの名前とかoriginal_userの名前を入れておく


class Message_check

  def initialize bot_name,original_name
    @bot_name = bot_name
    @original_name = original_name
  end


  def format_check tweet
    # フォーマットをチェックする
    # 返り値と処理
    # 0       追加
    # -1      エラー : 改行が含まれている
    # -2      エラー : フォーマットが違う
    # 1以上   数字の分だけ返信


    # original_usernameが含まれていない場合
    # 通常返信なので、bot_nameが含まれている数を返す
    if !has_username? tweet.text
      return count_botname tweet.text
    end

    # original_usernameが含まれているが、先頭がbot_nameで無い場合
    # 通常返信なので、bot_nameが含まれている数を返す
    if tweet.text.start_with? "@#{@bot_name}"
      return count_botname tweet.text
    end

    # 追加用のフォーマットかチェック
    add_check tweet.text
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

  def add_check text
    # 追加用フォーマットかのチェック
    # 返り値
    # 0   ヘッダがあっていて、一行
    # -1  エラー : ヘッダはあっているが、改行がある
    # -2  エラー : ヘッダがあっていない

    if check_header? text
      if text.include? "\n"
        # ヘッダはあっているけど改行含む
        -1
      else
        # ヘッダもあっていて改行無し
        0
      end
    else
      # ヘッダがあっていない
      -2
    end

  end

  def check_header? text
    # 夜フクロウからの非公式RT + リプ の場合を追加用ヘッダと考えて照らし合わせる

    @original_name.each do |name|
      return true if text.start_with? "@#{@bot_name} RT @#{name}: "
    end
    false
  end

end
