# frozen_string_literal: true

# カート内の品物の情報を扱うモデル
class ShoppingDetail < ApplicationRecord
  belongs_to :shopping

  before_validation :blank_name_format
  validate :item_count_size
  validate :item_price_size
  validate :name_length

  private

  def blank_name_format
    return unless item_name.blank?

    self.item_name = ''
  end

  def item_count_size
    return if item_count.to_i < 1000

    errors.add(:item_count, '1000個以上の同一の品物は入れられません')
  end

  def item_price_size
    return if item_price.to_i < 1_000_000

    errors.add(:item_price, '100万円以上の単価の品物は入れられません')
  end

  def name_length
    return if item_name.length <= 50

    errors.add(:item_name, '品名は50文字以内にしてください')
  end
end
