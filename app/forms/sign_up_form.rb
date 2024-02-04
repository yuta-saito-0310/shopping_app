# frozen_string_literal: true

# ユーザー登録用のオブジェクト
class SignUpForm
  include ActiveModel::Model

  attr_accessor :name, :email, :password, :pw_confirmation

  validate :user_valid?
  validate :pw_equal_to_pw_confirmation?

  private

  def user
    @user ||= User.new(name:, email:, password:)
  end

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

    errors.add(:password, :does_not_match_pw_confirmation,
               password_confirmation: I18n.t('shared.form.password_confirmation'))
  end
end
