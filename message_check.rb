#!/usr/local/bin/ruby
# -*- coding: utf-8 -*-

# メッセージをどう処理するのか決めるクラス
# botの名前とかoriginalのuser_namesを入れておく


class MessageCheck
  def initialize bot_name, original_names
    @bot_name = "@#{bot_name}"
    @original_names = original_names.map {|name| "@#{name}"}
  end

  def format_check tweet
    # フォーマットをチェックする
    # 返り値と処理
    # -1      追加
    # -2      エラー : 改行が含まれている
    # -3      エラー : フォーマットが違う
    # 0       リプライでない
    # 1以上   数字の分だけ返信

    # original_namesが含まれていない場合
    # あるいはoriginal_namesが含まれているが
    # 通常返信なので、先頭がbot_nameで無い場合
    # bot_nameが含まれている数を返す
    if !has_original_names?(tweet.text) || normal_reply?(tweet.text)
      return count_bot_name tweet.text
    end

    # 追加用のフォーマットかチェック
    add_check tweet.text
  end

  private
  def normal_reply? text
    not text.start_with? @bot_name
  end

  def has_original_names? text
    # original_namesが含まれているかどうか
    @original_names.any? {|name| text.include? name }
  end

  def count_bot_name text
    # bot_name の数を数える
    text.scan(@bot_name).size
  end

  def add_check text
    # 追加用フォーマットかのチェック

    # 改行コードを念のため\nに統一。
    text = text.encode universal_newline: true

    case [valid_header?(text), text.include?("\n")]
    when [true, false]
      # ヘッダもあっていて一行(ただしい)
      -1
    when [true, true]
      # ヘッダはあっているけど改行含む(エラー)
      -2
    else
      # ヘッダがあっていない(エラー)
      -3
    end
  end

  def valid_header? text
    # 夜フクロウからの非公式RT + リプ の場合を追加用ヘッダと考えて照らし合わせる
    @original_names.any? {|name| text.start_with? "#{@bot_name} RT #{name}: " }
  end
end
