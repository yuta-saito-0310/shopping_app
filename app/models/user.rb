# frozen_string_literal: true

# usersテーブルを扱うモデル
class User < ApplicationRecord
  has_many :shoppings
  has_many :word_suggestions

  before_validation :set_default_name
  before_validation :downcase_email
  validate :name_length
  validates :email, presence: true, uniqueness: true, email: { mode: :strict }
  validates :hashed_password, presence: true

  def password=(raw_password)
    if raw_password.is_a?(String)
      self.hashed_password = BCrypt::Password.create(raw_password)
    elsif raw_password.nil?
      self.hashed_password = nil
    end
  end

  private

  def set_default_name
    self.name = I18n.t('activerecord.attributes.user.nameless') if name.blank?
  end

  def name_length
    return unless name.length > 30

    errors.add(:name, :over_max_user_name_length)
  end

  def downcase_email
    self.email = email.downcase if email.present?
  end
end
