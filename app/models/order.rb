class Order < ApplicationRecord
  belongs_to :customer
  has_many :order_details
  has_many :items, through: :order_details
  
  enum payment_method: { credit_card: 0, transfer: 1 }
  enum status: { deposit_pending: 0, payment_confirmed: 1, in_making: 2, preparing_shipment: 3, shipped: 4 }
  
  
  validates :customer_id, presence: true
  validates :post_code, presence: true
  validates :address, presence: true
  validates :name, presence: true
  validates :shipping_cost, presence: true
  validates :total_payment, presence: true
  validates :payment_method, presence: true
  validates :status, presence: true
  
  
  def normalize_post_code
    self.post_code = self.post_code.tr("０-９ａ-ｚＡ-Ｚ（）－−", "0-9a-zA-Z()-")
  end
  
  def address_display
    '〒' + post_code + ' ' + address + ' ' + name
  end
end
