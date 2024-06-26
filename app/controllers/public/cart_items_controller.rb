class Public::CartItemsController < ApplicationController
  before_action :authenticate_customer!

  def index
    @cart_items = current_customer.cart_items.all
  end

  def create
    @cart_item = current_customer.cart_items.new(cart_item_params)  # 新しいカートアイテムを現在の顧客のカートに追加
    # もし既にカートに同じ商品がある場合、その数量を追加
    existing_cart_item = current_customer.cart_items.find_by(item_id: params[:cart_item][:item_id])
    if existing_cart_item.present?
      existing_cart_item.amount += params[:cart_item][:amount].to_i  # 数量を加算
      existing_cart_item.save
      redirect_to cart_items_path  # カートの一覧ページにリダイレクト
    # 既に同じ商品がカートにない場合、通常の保存処理を行う
    elsif @cart_item.save
      @cart_items = current_customer.cart_items.all  # 全てのカートアイテムを再取得
      render 'index'  # カートの一覧ページを再表示
    else
      # 保存できなかった場合
      render 'index'  # カートの一覧ページを再表示
    end
  end

  def update
    @cart_item = current_customer.cart_items.find(params[:id])  # 指定されたIDのカートアイテムを取得
    if @cart_item.update(cart_item_params)  # カートアイテムを更新
      redirect_to cart_items_path  # カートの一覧ページにリダイレクト
    else
      render 'index'  # 更新に失敗した場合、カートの一覧ページを再表示
    end
  end

  def destroy
    @cart_item = current_customer.cart_items.find(params[:id])  # 指定されたIDのカートアイテムを取得
    @cart_item.destroy  # カートアイテムを削除
    redirect_to cart_items_path  # カートの一覧ページにリダイレクト
  end

  def destroy_all
    current_customer.cart_items.destroy_all  # 現在の顧客の全てのカートアイテムを削除
    redirect_to cart_items_path  # カートの一覧ページにリダイレクト
  end

  private
    def cart_item_params
      params.require(:cart_item).permit(:item_id, :amount)
  end

end
