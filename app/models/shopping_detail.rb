# frozen_string_literal: true

# カート内の品物の情報を扱うモデル
class ShoppingDetail < ApplicationRecord
  belongs_to :shopping

  before_validation :blank_name_format
  validate :item_count_size
  validate :item_price_size
  validate :name_length
  validates :item_count, numericality: { only_integer: true }
  validates :item_price, numericality: { only_integer: true }

  private

  def blank_name_format
    return unless item_name.blank?

    self.item_name = ''
  end

  def item_count_size
    return if item_count.to_i < 1000

    errors.add(:item_count, :over_max_item_count)
  end

  def item_price_size
    return if item_price.to_i < 1_000_000

    errors.add(:item_price, :over_max_item_price, currency: I18n.t('activerecord.attributes.shopping_detail.currency'))
  end

  def name_length
    return if item_name.length <= 50

    errors.add(:item_name, :over_max_item_name_length)
  end
end
