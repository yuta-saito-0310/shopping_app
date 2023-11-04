# frozen_string_literal: true

# ユーザー登録用のオブジェクト
class SignUpForm
  include ActiveModel::Model

  attr_accessor :name, :email, :password, :pw_confirmation

  validate :user_valid?
  validate :pw_equal_to_pw_confirmation?

  def user
    @user ||= User.new(name:, email:, password:)
  end

  private

  # Userモデルのバリデーションを実行し、エラーを@formに格納する
  def user_valid?
    return true if user.valid?

    user.errors.messages.each do |attribute, messages|
      messages.each do |message|
        errors.add(attribute, message)
      end
    end
  end

  def pw_equal_to_pw_confirmation?
    return true if password == pw_confirmation

    errors.add(:password, 'パスワードが確認用パスワードと一致していません')
  end
end
