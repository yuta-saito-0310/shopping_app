# frozen_string_literal: true

# ユーザー新規作成に関するコントローラ
class UsersController < ApplicationController
  before_action :redirect_if_logged_in, only: [:new]
  skip_before_action :authorize

  def new
    @form = ::SignUpForm.new
    render action: 'new'
  end

  def create
    @form = ::SignUpForm.new(sign_up_form_params)
    if @form.valid?
      create_user_or_render_new
    else
      render action: 'new'
    end
  end

  private

  def redirect_if_logged_in
    user = current_user
    redirect_to new_user_shopping_path(user) if user.present?
  end

  def sign_up_form_params
    params.require(:sign_up_form).permit(:name, :email, :password, :pw_confirmation)
  end

  def create_user_or_render_new
    user = User.new(name: @form.name, email: @form.email, password: @form.password)
    if user.save!
      session[:user_id] = user.id
      redirect_to new_user_shopping_path(user)
    else
      render action: 'new'
    end
  end
end
