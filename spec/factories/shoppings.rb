# frozen_string_literal: true

FactoryBot.define do
  factory :shopping do
    name { 'factory_shopping' }
    association :user
  end
end
