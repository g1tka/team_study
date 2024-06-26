class Admin::ItemsController < ApplicationController
  before_action :authenticate_admin!
  
  def index
    items = Item.all
    @items = items.page(params[:page]).per(10)
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to admin_item_path(@item)
    else
      render :new
    end
  end

  def show
    @item = Item.find(params[:id])
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    if @item.update(item_params)
      redirect_to admin_item_path(@item)
    else
      render :edit
    end
  end

  private
  # createとupdateで使うストロングパラメータです。
  def item_params

    params.require(:item).permit(:image, :genre_id, :name, :introduction, :price, :is_active)

  end

end
