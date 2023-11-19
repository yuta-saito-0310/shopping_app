# frozen_string_literal: true

# 買物記録用のオブジェクト
class ShoppingForm
  include ActiveModel::Model

  attr_accessor :shopping_name, :carts
end
