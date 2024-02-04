# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to have_many(:shoppings) }

  describe 'nameのバリデーション' do
    let(:user) { FactoryBot.build(:user, name:) }
    before { user.save }

    context '31文字以上の名前が入力されたとき' do
      let(:name) { 'a' * 31 }

      it '無効になっていること' do
        expect(user).not_to be_valid
      end

      it 'エラーメッセージが含まれていること' do
        expect(user.errors[:name]).to eq(['は30文字以内にしてください'])
      end
    end

    context '名前が30文字以内の名前が入力されたとき' do
      let(:name) { 'a' * 30 }

      it '有効であること' do
        expect(user).to be_valid
      end
    end

    context '名前が空白のとき' do
      let(:name) { '      ' }

      it 'デフォルト名を保存すること' do
        expect(user.name).to eq('名無しさん')
      end
    end
  end

  describe 'emailのバリデーション' do
    let(:user) { FactoryBot.build(:user, email: 'user@email.com') }
    before { user.save }

    context '重複したメールアドレスを登録しようとしたとき' do
      let(:duplicate_email_user) { FactoryBot.build(:user, email: 'user@email.com') }

      it '無効になること' do
        expect(duplicate_email_user).not_to be_valid
      end
    end

    context '大文字で重複したメールアドレスを登録しようとしたとき' do
      let(:duplicate_email_user) { FactoryBot.build(:user, email: 'User@email.com') }

      it '無効になること' do
        expect(duplicate_email_user).not_to be_valid
      end
    end

    context '大文字のメールアドレスを登録しようとしたとき' do
      let(:big_email_user) { FactoryBot.create(:user, email: 'Big@email.com') }

      it 'メールアドレスが小文字に変換されて保存されていること' do
        expect(User.find_by(id: big_email_user.id).email).to eq('big@email.com')
      end
    end
  end

  describe 'パスワードのハッシュ化をテスト' do
    let(:user) { FactoryBot.build(:user, password:) }

    context 'パスワードがnilのとき' do
      let(:password) { nil }

      it '無効のメッセージが含まれていること' do
        user.valid?
        expect(user.errors[:hashed_password]).to include('を入力してください')
      end
    end

    context 'パスワードに任意のテキストが入っているとき' do
      let(:password) { 'hoge' }

      it 'hashed_passwordが長さ60の文字列になること' do
        expect(user.hashed_password).to be_kind_of(String)
        expect(user.hashed_password.size).to eq(60)
      end
    end
  end
end
