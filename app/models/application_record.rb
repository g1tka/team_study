class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  
  scope :latest, -> { order(created_at: :desc) }

end
