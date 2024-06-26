class OrderDetail < ApplicationRecord
  belongs_to :order
  belongs_to :item
  
  validates :order_id, presence: true
  validates :item_id, presence: true
  validates :price, presence: true
  validates :amount, presence: true
  validates :making_status, presence: true
  
  enum making_status: { not_started: 0, pending: 1, in_progress: 2, completed: 3, }
  
  def subtotal
    item.with_tax_price * amount  #order/showで使用。
  end
end
