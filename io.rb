#!/usr/local/bin/ruby
# -*- coding: utf-8 -*-
# 
# 一ファイル入出力をまとめるクラス

class File_io
  
  @normal_reply_filename = ""
  @add_reply_filename = ""
  @illegal_reply_filename = ""
  @multilne_reply_filename = ""

  def initialize path
    file_check path
    @path = path
    file_check @path + @normal_reply_filename
    file_check @path + @add_reply_filename
    file_check @path + @illegal_reply_filename
    file_check @path + @multilne_reply_filename
  end

  def file_check path
    if !FileTest.exist? path
      puts "#{path} は存在しません。終了します。"
      exit
    end
  end
  
  def open_file 
    # ファイルの内容をすべて読みこんで返す
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
