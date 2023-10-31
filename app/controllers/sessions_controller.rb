# frozen_string_literal: true

# ログインやログアウトの状態を作るコントローラー
class SessionsController < ApplicationController
  def new
    if current_user
      redirect_to :shopping
    else
      @form = ::LoginForm.new
      render action: 'new'
    end
  end

  def create
    @form = ::LoginForm.new(login_form_params)

    return unless @form.email.present?

    user = User.find_by('LOWER(email) = ?', @form.email.downcase)

    if ::Authenticator.new(user).authenticate(@form.password)
      session[:user_id] = user.id
      redirect_to :shopping
    else
      render action: 'new'
    end
  end

  private

  def login_form_params
    params.require(:login_form).permit(:email, :password)
  end
end
