# frozen_string_literal: true

# 全てのコントローラーの起動前に実行されるコントローラー
class ApplicationController < ActionController::Base
  helper_method :current_user
  before_action :authorize

  private

  def current_user
    return unless session[:user_id]

    @current_user ||= User.find_by(id: session[:user_id])
  end

  def authorize
    unless current_user
      flash.alert = 'ログインしてください'
      redirect_to new_sessions_path
    end
  end
end
