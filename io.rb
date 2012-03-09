#!/usr/local/bin/ruby
# -*- coding: utf-8 -*-
# 
# 一ファイル入出力をまとめるクラス

class File_io

  def initialize path
    # path が存在するか一応確認する
    file_check path
    @path = path
    files_load
  end

  def files_load
    # 各種ファイルの存在確認 + ロード
    # それぞれのファイル名は今のところベタ書き

    normal_reply_filename = "normal_replys.txt"
    add_reply_filename = "add_replys.txt"
    illegal_reply_filename = "illigal_replys.txt"
    multiline_reply_filename = "multiline_replys.txt"

    # 各種ファイルのロード
    @normal_replys = open_file "#{@path}/#{normal_reply_filename}"
    @add_replys = open_file "#{@path}/#{add_reply_filename}"
    @illigal_replys = open_file "#{@path}/#{illegal_reply_filename}"
    @multiline_replys = open_file "#{@path}/#{multiline_reply_filename}"

    # メッセージ追加用ファイルの存在確認
    # ファイル名は今のところベタ書き

    @add_tweet_file = "tweet_ngskbot.txt"
    @add_tweet_log_file = "tweet_ngskbot_log.txt"

    file_check "#{@path}/#{@add_tweet_file}"
    file_check "#{@path}/#{@add_tweet_log_file}"
  end

  attr_reader :normal_replys , :add_replys , :illigal_replys , :multiline_replys

  def add_tweet tweet,debug = true
    # めいげんの追加書き込み + ログ書き込みをする
    # 念のためデフォルトのデバッグフラグはtrue


    if debug
      puts "----- (debug mode : check write tweet ) ------"
      puts "追加予定の内容"
      puts get_text tweet.text
      puts "---- (debug mode : check write tweet end ) ----"
    else
      add_message("#{@path}/#{@add_tweet_file}",get_text(tweet.text)) # ツイート書き込み
      add_message("#{@path}/#{@add_tweet_log_file}",get_log(tweet))   # ログ書き込み
    end
  end


  private

  def file_check path
    if !FileTest.exist? path
      puts "#{path} は存在しません。終了します。"
      exit
    end
  end


  def open_file file_path
    # ファイルの内容をすべて読みこんで返す

    # ファイルの存在確認
    file_check file_path

    # 読み込み

    f = File.open(file_path,"r")
    file_text = f.read
    f.close
    file_text.split "\n"
  end

  def add_message file_path,msg
    # 指定ファイルに追加書き込みをする
    f = File.open(file_path,"a+")
    f.puts msg
    f.close
  end

  def get_text msg
    # ツイートから追加用テキストを取得する。
    # 夜フクの非公式RTを前提。
    # 今のところ結構ゴリ押し。

    # 非公式RTについてくる " :" で分割
    # 二番目にテキストが入ってくるので取りだす
    msg = msg.split(": ")[1]

    # 多段非公式RT会話時には、本人の最新発言部分のみもってくる
    # "RT "で分割。 会話内に入っている場合は分割点がずれる
    # 本人の最新発言分なので、先頭を取りだす

    msg = msg.split("RT ")[0]


    # リプライになりかねないように、@userなやつは消す。
    # ループで全部消す。

    while msg != msg.sub(/@[^ ]* /,"")
      msg = msg.sub(/@[^ ]* /,"")
    end

    msg
  end

end
