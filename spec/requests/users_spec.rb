# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'POST /users' do
    context '正しいパラメータの場合' do
      let(:valid_params) do
        {
          name: 'test_user',
          email: 'test@example.com',
          password: 'password',
          pw_confirmation: 'password'
        }
      end

      it '新しいユーザーを作成すること' do
        expect { post users_path, params: { sign_up_form: valid_params } }.to change(User, :count).by(+1)
        user = User.find_by(email: valid_params[:email])
        expect(response).to redirect_to(new_user_shopping_path(user))
      end
    end

    context '正しくないパラメータの場合' do
      let(:invalid_params) do
        {
          name: 'a' * 31,
          email: 'aaaaaaa',
          password: 'foo',
          pw_confirmation: 'bar'
        }
      end

      it '新しいユーザーが作成されないこと' do
        expect { post users_path, params: { sign_up_form: invalid_params } }.to_not change(User, :count)
        expect(response).to have_http_status(200)
      end

      it 'レスポンスにエラーメッセージが含まれること' do
        expect { post users_path, params: { sign_up_form: invalid_params } }.to_not change(User, :count)
        expect(response.body).to include('メールアドレス が不正な値です')
        expect(response.body).to include('名前 は30文字以内にしてください')
        expect(response.body).to include('パスワード が確認用パスワードと一致していません')
      end
    end
  end
end
