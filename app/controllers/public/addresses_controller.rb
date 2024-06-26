class Public::AddressesController < ApplicationController
  before_action :authenticate_customer!
  
  def index
    @address = current_customer.addresses.new  #フォーム入力用
    @addresses = current_customer.addresses.all  #index用
  end

  def create  #フォーム入力後
    @address = current_customer.addresses.new(address_params)
    if @address.save
      redirect_to addresses_path(address: @address)
    else
      @addresses = current_customer.addresses.all
      p @address.errors.full_messages # エラーメッセージを表示
      render :index
    end
  end

  def destroy
    @address = current_customer.addresses.find(params[:id])
    @address.destroy
    redirect_to addresses_path
  end

  def edit
    @address = current_customer.addresses.find(params[:id])
  end

  def update
    @address = current_customer.addresses.find(params[:id])
    if @address.update(address_params)
      redirect_to addresses_path
    else
      render :edit
    end
  end
  # address_display

  private
  def address_params
    params.require(:address).permit(:customer_id, :name, :address, :post_code)
  end
end
