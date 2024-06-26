class Public::OrdersController < ApplicationController
  before_action :authenticate_customer!

  def new
    @order = Order.new
  end

  def confirm
    @order = Order.new(order_params)
    @order.shipping_cost = 800

    if params[:order][:select_address] == "0"
      @order.post_code = current_customer.post_code
      @order.address = current_customer.address
      @order.name = current_customer.last_name + current_customer.first_name
      
    elsif params[:order][:select_address] == "1"
      @address = Address.find(params[:order][:address_id]) # orderのaddress_idカラムでアドレス帳id=xを取得
      @order.post_code = @address.post_code
      @order.address = @address.address
      @order.name = @address.name
      
    elsif params[:order][:select_address] == "2"
      @order.post_code = params[:order][:post_code]
      @order.address = params[:order][:address]
      @order.name = params[:order][:name]
      
    else
      render "new"
    end

    @cart_items = current_customer.cart_items.all


  end

  def create
    # Orderモデルに注文を保存
    @order = Order.new(order_params)
    @order.save
    # Order_detailモデルに注文を保存
    @cart_items = current_customer.cart_items.all
    @cart_items.each do |cart_item|
      @order_details = OrderDetail.new      #毎商品で作りたい。
      @order_details.order_id = @order.id
      @order_details.item_id = cart_item.item.id
      @order_details.price = cart_item.item.with_tax_price
      @order_details.amount = cart_item.amount
      @order_details.making_status = 0
      @order_details.save!
    end

    CartItem.destroy_all
    redirect_to thanks_orders_path
  end

  def thanks
  end

# .latestmethodはApplicationモデルに記載。created_at の値を降順で並び替える機能。
  def index
    @orders = current_customer.orders.latest
  end

  def show
    @order = current_customer.orders.find(params[:id])
    @order.shipping_cost = 800
  end

  private
    def order_params
      params.require(:order).permit(:customer_id, :post_code, :address, :name, :shipping_cost, :total_payment, :payment_method, :status)
    end
end
