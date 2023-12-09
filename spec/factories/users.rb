# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "'factory_tester_#{n}" }
    sequence(:email) { |n| "'factory_tester#{n}@email.com" }
    password { 'factory_pw' }
  end
end
