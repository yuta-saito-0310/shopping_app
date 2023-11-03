# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Authenticator do
  describe '#authenticate' do
    let(:user) { FactoryBot.build(:user, password: 'correct_pw') }
    let(:auth) { Authenticator.new(user) }

    context '間違えたパスワードが入力されたとき' do
      it 'falseを返すこと' do
        expect(auth.authenticate('false_pw')).to eq(false)
      end
    end

    context '正しいパスワードが入力されたとき' do
      it 'trueを返すこと' do
        expect(auth.authenticate('correct_pw')).to eq(true)
      end
    end

    context '設定されたパスワードが空白だったとき' do
      let(:user) { FactoryBot.build(:user, password: '') }

      context '適当な文字列を入力したとき' do
        it 'falseを返すこと' do
          expect(auth.authenticate('abcd')).to eq(false)
        end
      end

      context '空白のパスワードを入力したとき' do
        it 'trueを返すこと' do
          expect(auth.authenticate('')).to eq(true)
        end
      end
    end
  end
end
