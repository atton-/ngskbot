# -*- coding: utf-8 -*-
# ngskbot 起動用。
# 各種パスはcron用に絶対パスで。

bot_name = "nkgbot.rb"
setting_file_name = "settings.txt"
log_file = "ngskbot_log.txt"

dir = File.dirname __FILE__

puts "nohup ruby #{dir}/#{bot_name} #{dir}/#{setting_file_name} >> ~/#{log_file} &"
