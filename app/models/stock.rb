class Stock < ApplicationRecord
  belongs_to :product
  self.table_name = "admin_stocks"
end
