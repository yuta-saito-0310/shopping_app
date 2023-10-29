# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { 'factory_user' }
    sequence(:email) { |n| "'factory_tester#{n}@email.com" }
    password { 'factory_pw' }
  end
end
