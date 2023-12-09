# frozen_string_literal: true

# 買物記録用のオブジェクト
class ShoppingForm
  include ActiveModel::Model

  attr_accessor :shopping_name, :cart, :user_id

  def save_shopping_form
    ActiveRecord::Base.transaction do
      shopping = Shopping.create!(name: shopping_name, user_id:)
      save_shopping_details(shopping)
    rescue StandardError => e
      errors.add(:base, e.message)
      raise ActiveRecord::Rollback
    end
  end

  private

  def save_shopping_details(shopping)
    cart.each do |item_info|
      item_price = item_info[:item_price]
      item_count = item_info[:item_count]
      item_name = item_info[:item_name]

      ShoppingDetail.create!(item_name:, item_price:, item_count:, shopping_id: shopping.id)
    end
  end
end
