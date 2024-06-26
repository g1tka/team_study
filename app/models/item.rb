class Item < ApplicationRecord

  #商品説明欄で、半角で入力された数字や記号を半角に変換する処理
  before_save :normalize_introduction

  def normalize_introduction
    self.introduction = self.introduction.tr("０-９ －", "0-9 -")
  end

  #before_save :normalize_post_code

  #def normalize_post_code
    #self.post_code = self.post_code.tr("０-９ －", "0-9 -")
  #end
  #商品編集後保存が出来なかった為、修正しました。
  
  has_one_attached :image

  belongs_to :genre
  has_many :cart_items, dependent: :destroy
  has_many :order_details, dependent: :destroy
  has_many :orders, through: :order_details

  def get_image
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    image.variant(resize_to_fill: [180, 120]).processed
  end

  validates :genre_id, presence: true
  validates :name, presence: true
  validates :introduction, presence: true
  validates :price, presence: true
  validates :is_active, inclusion: {in: [true, false]}

  def with_tax_price
    (price * 1.1).floor
  end
end