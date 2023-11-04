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

    if @form.email.blank?
      @form.errors.add(:email, 'メールアドレスが空白です')
      return render action: 'new'
    end

    user = User.find_by('LOWER(email) = ?', @form.email.downcase)

    login_or_render_new(user)
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end

  private

  def login_form_params
    params.require(:login_form).permit(:email, :password)
  end

  def login_or_render_new(user)
    if user && ::Authenticator.new(user).authenticate(@form.password)
      session[:user_id] = user.id
      redirect_to :shopping
    else
      @form.errors.add(:base, 'メールアドレスまたはパスワードが無効です')
      render action: 'new'
    end
  end
end
