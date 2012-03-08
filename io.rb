#!/usr/local/bin/ruby
# -*- coding: utf-8 -*-
# 
# 一ファイル入出力をまとめるクラス

class File_io
  
  def initialize path
    if !FileTest.exist? path
      puts "#{path} は存在しません。終了します。"
      exit
    end
    @path = path
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

hoge = File_io.new "./hoge.txt"
puts hoge.open_file
hoge.add_message "hogehoge"
puts hoge.open_file
