# frozen_string_literal: true

# ユーザー新規作成に関するコントローラ
class UsersController < ApplicationController
  before_action :redirect_if_logged_in, only: [:new]
  before_action :initialize_form, only: [:create]
  before_action :validate_form, only: [:create]

  def new
    @form = ::SignUpForm.new
    render action: 'new'
  end

  def create
    user = User.new(name: @form.name, email: @form.email, password: @form.password)
    if user.save!
      session[:user_id] = user.id
      redirect_to shopping_path
    else
      render action: 'new'
    end
  end

  private

  def redirect_if_logged_in
    redirect_to :shopping if current_user
  end

  def initialize_form
    @form = ::SignUpForm.new(sign_up_form_params)
  end

  def validate_form
    return if @form.email.present? && @form.password == @form.pw_confirmation

    render action: 'new'
  end

  def sign_up_form_params
    params.require(:sign_up_form).permit(:name, :email, :password, :pw_confirmation)
  end
end
