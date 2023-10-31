# frozen_string_literal: true

require 'active_model'

# ユーザーログイン用のオブジェクト
class LoginForm
  include ActiveModel::Model

  attr_accessor :email, :password
end
