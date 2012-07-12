# -*- coding: utf-8 -*-
require 'spec_helper'

describe MessageCheck do
  let (:bot_name) { 'ngskbot' }
  let (:original_names) { ['hamilton___', 'daijoubujanee'] }
  let (:original_name) { original_names.last }

  subject { MessageCheck.new(bot_name, original_names) }

  describe 'MessageCheck#format_check?' do
    context 'textがoriginal_nameを含まないとき' do
      it ('bot_nameを数えた数を返す') {
        text = "@#{original_name} @#{bot_name}" * 5
        subject.format_check(stub(text: text)).should eq 5
      }
    end

    context 'textがoriginal_nameを含むとき' do
      context 'bot_nameからはじまっていて' do
        let(:valid_format) { "@#{bot_name} RT @#{original_name}: " }
        let(:invalid_format) { "@#{bot_name} @#{original_name}" }

        context 'ただしいフォーマットで' do
          context '1行のとき' do
            it ('-1を返す') {
              subject.format_check(stub(text: valid_format)).should eq -1
            }
          end

          context '改行を含むとき' do
            it ('エラーの-2を返す') {
              subject.format_check(stub(text: "#{valid_format}\n")).should eq -2
            }
          end
        end

        context 'ただしくないフォーマットのとき' do
          it ('-3を返す') {
            subject.format_check(stub(text: invalid_format)).should eq -3
          }
        end
      end

      context 'bot_nameからはじまらないとき' do
        it ('bot_nameを数えた数を返す') {
          text = "@#{original_name} @#{bot_name}" * 5
          subject.format_check(stub(text: text)).should eq 5
        }
      end
    end
  end
end
