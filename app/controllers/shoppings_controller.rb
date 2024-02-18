# frozen_string_literal: true

# カート内の計算結果をフロントエンドとやり取りするコントローラー
class ShoppingsController < ApplicationController
  def index
    @shoppings = Shopping.where(user_id: session[:user_id])
  end

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

  def modal
    shopping = @current_user.shoppings.includes(:shopping_details).find(params[:id])

    result = make_result_hash(shopping)

    render json: result
  rescue ActiveRecord::RecordNotFound => e
    logger.info("[E]error happend: #{e}")
    render json: { error: I18n.t('errors.messages.not_found') }, status: :not_found
  rescue StandardError => e
    logger.info("[E]error happend: #{e}")
    render json: { error: I18n.t('errors.messages.internal_server_error') }, status: :internal_server_error
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

  def make_result_hash(shopping)
    result = {}

    result[:shopping_name] = shopping.name

    result[:shopping_details] = shopping.shopping_details.map do |detail|
      {
        item_name: detail.item_name,
        item_count: detail.item_count,
        item_price: detail.item_price
      }
    end

    result
  end
end
