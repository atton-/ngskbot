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
    # 各種ファイルの存在確認。
    # それぞれのファイル名は今のところベタ書き
    
    normal_reply_filename = "n"
    add_reply_filename = "a"
    illegal_reply_filename = "i"
    multilne_reply_filename = "m"
    
    # 各種ファイルのロード
    @normal_replys = open_file "#{@path}/#{normal_reply_filename}"
    @add_replys = open_file "#{@path}/#{add_reply_filename}"
    @illigal_replys = open_file "#{@path}/#{illegal_reply_filename}"
    @multiline_replys = open_file "#{@path}/#{multilne_reply_filename}"
  end
  
  attr_reader :normal_replys , :add_replys , :illigal_replys , :multiline_replys

  def file_check path
    puts path
    if !FileTest.exist? path
      puts "#{path} は存在しません。終了します。"
      exit
    end
  end

  def open_file file_name
    # ファイルの内容をすべて読みこんで返す
    
    # ファイルの存在確認
    file_check file_name
    
    # 読み込み
    file_processing do |file|
      return file.read
    end
  end

  def add_message msg
    file_processing do |file|
      file.puts msg
    end
  end

  def file_processing 
    # fileのopenとcloseを受けもつ
    f = File.open(@path,"a+")
    yield f
    f.close
  end
end
