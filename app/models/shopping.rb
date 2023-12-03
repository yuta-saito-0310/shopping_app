# frozen_string_literal: true

# 買物データを扱う親モデル
class Shopping < ApplicationRecord
  belongs_to :user
  has_many :shopping_details

  before_validation :set_default_shopping_name
  validate :name_length

  private

  def set_default_shopping_name
    return unless name.blank?

    current_time = Time.now
    self.name = current_time.strftime('%Y年%m月%d日の買物')
  end

  def name_length
    return unless name.length > 50

    errors.add(:name, '名前は50文字以内にしてください')
  end
end
