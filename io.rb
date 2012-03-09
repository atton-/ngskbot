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
    
    normal_reply_filename = "normal_replys.txt"
    add_reply_filename = "add_replys.txt"
    illegal_reply_filename = "illigal_replys.txt"
    multilne_reply_filename = "multiline_replys.txt"
    
    # 各種ファイルのロード
    @normal_replys = open_file "#{@path}/#{normal_reply_filename}"
    @add_replys = open_file "#{@path}/#{add_reply_filename}"
    @illigal_replys = open_file "#{@path}/#{illegal_reply_filename}"
    @multiline_replys = open_file "#{@path}/#{multilne_reply_filename}"
  end
  
  attr_reader :normal_replys , :add_replys , :illigal_replys , :multiline_replys

  def file_check path
    puts "hogehogeho : #{path}"
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
    f = File.open(file_path,"a+")
    f.puts msg
    f.close
  end

end
