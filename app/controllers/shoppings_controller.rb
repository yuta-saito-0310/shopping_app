# frozen_string_literal: true

# カート内の計算結果をフロントエンドとやり取りするコントローラー
class ShoppingsController < ApplicationController
  def new
    @form = ::ShoppingForm.new
    render action: 'new'
  end

  def create
    @form = ::ShoppingForm.new(shopping_form_params)
    @form.user_id = session[:user_id]

    return render_new_with_error if params[:user_id].to_i != session[:user_id]

    save_shopping_form_and_redirect
  end

  private

  def shopping_form_params
    params.require(:shopping_form).permit(:shopping_name, cart: %i[item_name item_price item_count])
  end

  def render_new_with_error
    @form.errors.add(:base, '不正なユーザーIDでリクエストしました')
    render action: 'new'
  end

  def save_shopping_form_and_redirect
    @form.save_shopping_form

    if @form.errors.empty?
      redirect_to user_shoppings_path
    else
      render action: 'new'
    end
  end
end
