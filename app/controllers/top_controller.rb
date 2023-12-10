# frozen_string_literal: true

# ルートページを表示するコントローラ
class TopController < ApplicationController
  skip_before_action :authorize

  def home; end
end
