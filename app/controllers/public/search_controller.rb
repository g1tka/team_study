class Public::SearchController < ApplicationController
  
  def index
    @query = params[:query]
    @items = Item.where('name LIKE ?', "%#{@query}%")
    @genres_all = Genre.all
    @item_count = @items.count

  end
end
