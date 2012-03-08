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
    # -1      追加
    # -2      エラー : 改行が含まれている
    # -3      エラー : フォーマットが違う
    # 0       リプライでない
    # 1以上   数字の分だけ返信

    # original_usernameが含まれていない場合
    # bot_nameが含まれている数を返す
    if !has_username? tweet.text
      return count_botname tweet.text
    end

    # original_usernameが含まれているが、先頭がbot_nameで無い場合
    # 通常返信なので、bot_nameが含まれている数を返す
    if !tweet.text.start_with? "@#{@bot_name}"
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
    # -1  正しいフォーマット : ヘッダがあっていて、一行
    # -2  エラー : ヘッダはあっているが、改行がある
    # -3  エラー : ヘッダがあっていない
    
    # 改行コードを念のため\nに統一。
    # 全部やったほうが良いけど、一つあれば引っかかるので一回だけ。
    text.sub! "\r\n","\n"
    text.sub! "\r","\n"

    if check_header? text
      if text.include? "\n"
        # ヘッダはあっているけど改行含む
        -2
      else
        # ヘッダもあっていて改行無し
        -1
      end
    else
      # ヘッダがあっていない
      -3
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
