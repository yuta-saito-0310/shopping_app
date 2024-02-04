# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ShoppingDetail, type: :model do
  it { is_expected.to belong_to(:shopping) }

  describe 'item_countのバリデーション' do
    let(:shopping_detail) { FactoryBot.build(:shopping_detail, item_count:) }

    context '1つの品物の数が1000個以上のとき' do
      let(:item_count) { '1000' }

      it '無効になっていること' do
        expect(shopping_detail).not_to be_valid
      end

      it 'エラーメッセージが含まれていること' do
        shopping_detail.valid?
        expect(shopping_detail.errors[:item_count]).to eq(['は1000以上を指定できません'])
      end
    end

    context '1つの品物の数が1000個未満のとき' do
      let(:item_count) { '999' }

      it '有効になっていること' do
        expect(shopping_detail).to be_valid
      end
    end

    context '1つの品物の数が文字列のとき' do
      let(:item_count) { 'string' }

      it '無効になっていること' do
        expect(shopping_detail).not_to be_valid
      end

      it 'エラーメッセージが含まれていること' do
        shopping_detail.valid?
        expect(shopping_detail.errors[:item_count]).to eq(['は数値を入力してください'])
      end
    end
  end

  describe 'item_priceのバリデーション' do
    let(:shopping_detail) { FactoryBot.build(:shopping_detail, item_price:) }

    context '1つの品物の単価が100万円以上のとき' do
      let(:item_price) { '1000000' }

      it '無効になっていること' do
        expect(shopping_detail).not_to be_valid
      end

      it 'エラーメッセージが含まれていること' do
        shopping_detail.valid?
        expect(shopping_detail.errors[:item_price]).to eq(['は1,000,000円以上は指定できません'])
      end
    end

    context '1つの品物の数が1000個未満のとき' do
      let(:item_price) { '999999' }

      it '有効になっていること' do
        expect(shopping_detail).to be_valid
      end
    end

    context '1つの品物のが単価が文字列のとき' do
      let(:item_price) { 'string' }

      it '無効になっていること' do
        expect(shopping_detail).not_to be_valid
      end

      it 'エラーメッセージが含まれていること' do
        shopping_detail.valid?
        expect(shopping_detail.errors[:item_price]).to eq(['は数値を入力してください'])
      end
    end
  end

  describe 'item_nameのバリデーション' do
    let(:shopping_detail) { FactoryBot.build(:shopping_detail, item_name:) }

    context 'item_nameが50文字より大きいとき' do
      let(:item_name) { 'a' * 51 }

      it '無効であるになっていること' do
        expect(shopping_detail).not_to be_valid
      end

      it 'エラーメッセージが含まれていること' do
        shopping_detail.valid?
        expect(shopping_detail.errors[:item_name]).to eq(['は50文字以内にしてください'])
      end
    end

    context 'item_nameが50文字以内のとき' do
      let(:item_name) { 'a' * 50 }

      it '有効であること' do
        expect(shopping_detail).to be_valid
      end
    end

    context 'item_nameが空白のとき' do
      let(:item_name) { '        ' }

      it '有効であること' do
        expect(shopping_detail).to be_valid
      end

      it 'item_nameが空白で保存されていること' do
        shopping_detail.save
        expect(shopping_detail.item_name).to eq('')
      end
    end
  end
end
