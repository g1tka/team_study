class Admin::OrderDetailsController < ApplicationController
  before_action :authenticate_admin!

  def update
    @order_detail = OrderDetail.find(params[:id])
    @order = @order_detail.order
    if @order_detail.update(order_detail_params)

      # Check if any order detail is in progress
      if @order_detail.making_status == "in_progress"
        @order.update(status: :in_making)

      # Check if all order details are completed
      elsif @order.order_details.all? { |detail| detail.completed? }
        @order.update(status: :preparing_shipment)
      end
    end

    redirect_to admin_order_path(@order)
  end

  private

  def order_detail_params
    params.require(:order_detail).permit(:making_status)
  end
end