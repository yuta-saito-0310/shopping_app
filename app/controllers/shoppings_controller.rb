# frozen_string_literal: true

# カート内の計算結果をフロントエンドとやり取りするコントローラー
class ShoppingsController < ApplicationController
  def new
    @form = ::ShoppingForm.new
    render action: 'new'
  end

  def create
    @form = ::ShoppingForm.new(shopping_form_params)
    if @form.valid?
      create_shopping_or_render_new
    else
      render action: 'new'
    end
  end

  private

  def shopping_form_params
    binding.irb
    params.require(:shopping_form).permit(:shopping_name, items_name[])
  end

  def create_shopping_or_render_new
  end
end
