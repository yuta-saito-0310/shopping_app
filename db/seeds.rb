# frozen_string_literal: true

user = User.create!(
  name: 'seed_user',
  email: 'seed@email.com',
  password: 'seed'
)

3.times do |parent_index|
  shopping = Shopping.create!(
    name: "shopping_#{parent_index + 1}",
    user_id: user.id
  )

  5.times do |child_index|
    ShoppingDetail.create!(
      item_name: "shopping_#{parent_index + 1}_item_#{child_index + 1}",
      item_count: 10,
      item_price: 200,
      shopping_id: shopping.id
    )
  end
end
