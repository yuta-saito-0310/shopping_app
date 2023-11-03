# frozen_string_literal: true

# ユーザー登録用のオブジェクト
class SignUpForm
  include ActiveModel: :Model

  attr_accessor :email, :password, :pw_confirmation
end