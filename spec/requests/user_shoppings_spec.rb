# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Shoppings', type: :request do
  let(:user) { FactoryBot.create(:user) }

  describe 'GET /users/:user_id/shoppings' do
    subject { get user_shoppings_path(user) }

    context 'ユーザーがログインしていなかったとき' do
      it 'ログイン画面にリダイレクトすること' do
        is_expected.to redirect_to(new_sessions_path)
      end
    end

    context 'ユーザーがログインしている場合' do
      before do
        post sessions_path, params: { login_form: { email: user.email, password: 'factory_pw' } }
        post user_shoppings_path(user), params:
      end
      let(:params) do
        {
          shopping_form: {
            shopping_name: 'shopping_1',
            cart: [{ item_name: 'item_1', item_price: '100', item_count: '1' },
                   { item_name: 'item_2', item_price: '200', item_count: '2' }]
          }
        }
      end

      it 'indexページが表示されること' do
        subject
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'GET /users/:user_id/shoppings/new' do
    subject { get new_user_shopping_path(user) }
    context 'ユーザーがログインしていなかったとき' do
      it 'ログイン画面にリダイレクトすること' do
        is_expected.to redirect_to(new_sessions_path)
      end
    end

    context 'ユーザーがログインしている場合' do
      before { post sessions_path, params: { login_form: { email: user.email, password: 'factory_pw' } } }

      it 'カート作成ページが表示されること' do
        subject
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'POST /users/:user_id/shoppings' do
    subject { post user_shoppings_path(user), params: }
    context 'ユーザーがログインしている場合' do
      before { post sessions_path, params: { login_form: { email: user.email, password: 'factory_pw' } } }

      context 'パラメータが正しい場合' do
        let(:params) do
          {
            shopping_form: {
              shopping_name: 'shopping_1',
              cart: [{ item_name: 'item_1', item_price: '100', item_count: '1' },
                     { item_name: 'item_2', item_price: '200', item_count: '2' }]
            }
          }
        end

        it 'リクエストが成功すること' do
          is_expected.to redirect_to(user_shoppings_path)
        end

        it 'データが作成されていること' do
          expect { subject }.to change(Shopping, :count).by(+1).and change(ShoppingDetail, :count).by(+2)
        end
      end

      context 'パラメータが不正の場合' do
        context 'shopping_nameが不正の場合' do
          let(:params) do
            {
              shopping_form: {
                shopping_name: 'a' * 51,
                cart: [{ item_name: 'item_1', item_price: '100', item_count: '1' },
                       { item_name: 'item_2', item_price: '200', item_count: '2' }]
              }
            }
          end

          it 'カート作成ページが表示されること' do
            is_expected.to eq(200)
          end

          it 'エラーメッセージが含まれていること' do
            subject
            expect(response.body).to include('買物名 は50文字以内にしてください')
          end

          it 'データが作成されていないこと' do
            expect { subject }.not_to(change { [Shopping.count, ShoppingDetail.count] })
          end
        end

        context 'item_priceとitem_countが不正の場合' do
          context 'パラメータが文字列の場合' do
            let(:params) do
              {
                shopping_form: {
                  shopping_name: 'shopping_name',
                  cart: [{ item_name: 'item_1', item_price: 'abc', item_count: 'def' },
                         { item_name: 'item_2', item_price: '200', item_count: '2' }]
                }
              }
            end

            it 'カート作成ページが表示されること' do
              is_expected.to eq(200)
            end

            it 'エラーメッセージが含まれていること' do
              subject
              expect(response.body).to include('品数 は数値を入力してください', '品物の単価 は数値を入力してください')
            end

            it 'データが作成されていないこと' do
              expect { subject }.not_to(change { [Shopping.count, ShoppingDetail.count] })
            end
          end

          context 'パラメータが桁オーバーの場合' do
            let(:params) do
              {
                shopping_form: {
                  shopping_name: 'shopping_name',
                  cart: [{ item_name: 'item_1', item_price: '1000000', item_count: '1000' },
                         { item_name: 'item_2', item_price: '200', item_count: '2' }]
                }
              }
            end

            it 'カート作成ページが表示されること' do
              is_expected.to eq(200)
            end

            it 'エラーメッセージが含まれていること' do
              subject
              expect(response.body).to include('品数 は1000以上を指定できません', '品物の単価 は1,000,000円以上は指定できません')
            end

            it 'データが作成されていないこと' do
              expect { subject }.not_to(change { [Shopping.count, ShoppingDetail.count] })
            end
          end
        end

        context 'shopping_nameとcartのパラメータが両方不正だった場合' do
          let(:params) do
            {
              shopping_form: {
                shopping_name: 'a' * 51,
                cart: [{ item_name: 'item_1', item_price: '1000000', item_count: '1000' },
                       { item_name: 'item_2', item_price: '200', item_count: '2' }]
              }
            }
          end

          it 'カート作成ページが表示されること' do
            is_expected.to eq(200)
          end

          it 'shopping_nameのエラーメッセージのみが含まれていること' do
            subject
            expect(response.body).to include('買物名 は50文字以内にしてください')
            expect(response.body).to exclude('品数 は1000以上を指定できません', '品物の単価 は1,000,000円以上は指定できません')
          end

          it 'データが作成されていないこと' do
            expect { subject }.not_to(change { [Shopping.count, ShoppingDetail.count] })
          end
        end

        context 'cartの中の1つ目のitemと2つ目のitemのパラメータが両方不正だった場合' do
          let(:params) do
            {
              shopping_form: {
                shopping_name: 'shopping_name',
                cart: [{ item_name: 'item_1', item_price: '1000000', item_count: '10' },
                       { item_name: 'item_2', item_price: '200', item_count: 'string' }]
              }
            }
          end

          it 'カート作成ページが表示されること' do
            is_expected.to eq(200)
          end

          it '1つ目のitemのエラーのみが含まれていること' do
            subject
            expect(response.body).to include('品物の単価 は1,000,000円以上は指定できません')
            expect(response.body).to exclude('品数は 数字で記入する必要があります')
          end

          it 'データが作成されていないこと' do
            expect { subject }.not_to(change { [Shopping.count, ShoppingDetail.count] })
          end
        end

        context 'ログインしているユーザーと別のユーザーIDを指定してリクエストを送った場合' do
          subject { post user_shoppings_path(user2), params: }

          let(:user2) { FactoryBot.create(:user) }

          let(:params) do
            {
              shopping_form: {
                shopping_name: 'shopping_name',
                cart: [{ item_name: 'item_1', item_price: '100', item_count: '10' },
                       { item_name: 'item_2', item_price: '200', item_count: '20' }]
              }
            }
          end

          it 'カート作成ページが表示されること' do
            is_expected.to eq(200)
          end

          it 'レスポンスにエラーメッセージが含まれていること' do
            subject
            expect(response.body).to include('不正なユーザーIDでリクエストしました')
          end

          it 'データが作成されていないこと' do
            expect { subject }.not_to(change { [Shopping.count, ShoppingDetail.count] })
          end
        end
      end
    end

    context 'ユーザーがログインしていない場合' do
      let(:params) do
        {
          shopping_form: {
            shopping_name: 'shopping_1',
            cart: [{ item_name: 'item_1', item_price: '100', item_count: '1' },
                   { item_name: 'item_2', item_price: '200', item_count: '2' }]
          }
        }
      end

      it 'ログイン画面にリダイレクトすること' do
        subject
        expect(response).to redirect_to(new_sessions_path)
      end
    end
  end

  describe 'GET /users/:user_id/shoppings/:id/modal' do
    subject { get modal_user_shopping_path(user, shopping) }

    let(:user) { FactoryBot.create(:user) }
    let(:shopping) { Shopping.create(name: 'test', user_id: user.id) }
    let!(:detail1) do
      ShoppingDetail.create(item_name: 'item1', item_count: 1, item_price: 100, shopping_id: shopping.id)
    end
    let!(:detail2) do
      ShoppingDetail.create(item_name: 'item2', item_count: 2, item_price: 200, shopping_id: shopping.id)
    end

    context '正常系' do
      before { post sessions_path, params: { login_form: { email: user.email, password: 'factory_pw' } } }

      it '買物名が返されること' do
        subject
        body = JSON.parse(response.body)

        expect(body['shopping_name']).to eq('test')
      end

      it '購入情報が返されること' do
        subject
        body = JSON.parse(response.body)

        expect(body['shopping_details']).to match_array([
                                                          { 'item_name' => 'item1', 'item_count' => 1,
                                                            'item_price' => 100 },
                                                          { 'item_name' => 'item2', 'item_count' => 2,
                                                            'item_price' => 200 }
                                                        ])
      end
    end

    context '準正常系' do
      context 'ユーザーがログインしていなかったとき' do
        it 'ログイン画面にリダイレクトすること' do
          subject
          expect(response).to redirect_to(new_sessions_path)
        end
      end

      context '他のユーザーでログインしているとき' do
        before { post sessions_path, params: { login_form: { email: user2.email, password: 'factory_pw' } } }

        let(:user2) { FactoryBot.create(:user) }

        it '404が返されること' do
          is_expected.to eq(404)
        end

        it 'エラーメッセージが返されること' do
          subject
          body = JSON.parse(response.body)

          expect(body['error']).to eq('該当するデータが見つかりません')
        end
      end
    end

    context '異常系' do
      before do
        post sessions_path, params: { login_form: { email: user.email, password: 'factory_pw' } }
        allow_any_instance_of(User).to receive_message_chain(:shoppings, :includes, :find).and_raise(StandardError)
      end

      context '何かしらのエラーが発生したとき' do
        it '500が返されること' do
          is_expected.to eq(500)
        end

        it 'エラーメッセージが返されること' do
          subject
          body = JSON.parse(response.body)

          expect(body['error']).to eq('サーバーエラーが発生しました')
        end
      end
    end
  end
end
