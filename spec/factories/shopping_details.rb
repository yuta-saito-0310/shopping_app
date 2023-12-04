# frozen_string_literal: true

FactoryBot.define do
  factory :shopping_detail do
    item_name { 'item_1' }
    item_count { '10' }
    item_price { '500' }
    association :shopping
  end
end
