# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Shopping, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:shopping_details) }

  describe 'nameのバリデーション' do
    let(:shopping) { FactoryBot.build(:shopping, name:) }

    context '51文字以上の名前が入力されたとき' do
      let(:name) { 'a' * 51 }

      it '無効になっていること' do
        expect(shopping).not_to be_valid
      end
    end

    context '50文字以下の名前が入力されたとき' do
      let(:name) { 'a' * 50 }

      it '有効になっていること' do
        expect(shopping).to be_valid
      end
    end
  end
end
