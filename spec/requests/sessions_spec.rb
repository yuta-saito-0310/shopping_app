# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  let!(:user) { FactoryBot.create(:user) }
  describe 'GET /login' do
    context 'ユーザーがログインしていなかったとき' do
      it 'ログイン画面の表示に成功すること' do
        get new_user_path
        expect(response).to have_http_status(200)
      end
    end

    context 'ユーザーがログイン状態だったとき' do
      it '/shoppingにリダイレクトすること' do
        post sessions_path, params: { login_form: { email: user.email, password: 'factory_pw' } }
        get new_user_path
        expect(response).to redirect_to(new_user_shopping_path(user))
      end
    end
  end

  describe 'POST /session' do
    context '正しいログイン情報をフォームに記載した場合' do
      before { post sessions_path, params: { login_form: { email: user.email, password: 'factory_pw' } } }
      it '/shoppingにリダイレクトすること' do
        expect(response).to redirect_to(new_user_shopping_path(user))
      end

      it 'ログインユーザーのsessionオブジェクトが作られること' do
        expect(session[:user_id]).to eq(user.id)
      end
    end

    context '誤ったメールアドレスをログインフォームに記載した場合' do
      before { post sessions_path, params: { login_form: { email: 'nobody@email.com', password: 'factory_pw' } } }
      it 'ログイン画面が表示されること' do
        expect(response).to have_http_status(200)
      end

      it 'レスポンスにエラーメッセージが含まれること' do
        expect(response.body).to include('メールアドレスまたはパスワードが無効です')
      end
    end

    context '誤ったパスワードをフォームに記載した場合' do
      before { post sessions_path, params: { login_form: { email: user.email, password: 'uncorrect_pw' } } }
      it 'ログイン画面が表示されること' do
        expect(response).to have_http_status(200)
      end

      it 'レスポンスにエラーメッセージが含まれること' do
        expect(response.body).to include('メールアドレスまたはパスワードが無効です')
      end
    end
  end

  describe 'DELETE /sessions' do
    context 'ログイン状態からログアウトした場合' do
      before do
        post sessions_path, params: { login_form: { email: user.email, password: 'factory_pw' } }
        delete sessions_path
      end

      it 'ルートページにリダイレクトすること' do
        expect(response).to redirect_to(root_path)
      end

      it 'ログインユーザーのsessionオブジェクトがなくなっていること' do
        expect(session[:user_id]).to eq(nil)
      end
    end

    context 'ログアウト状態からログアウトリクエストを送信した場合' do
      before { delete sessions_path }

      it 'ルートページにリダイレクトすること' do
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
