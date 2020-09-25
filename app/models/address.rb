class Address < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :temporary
  belongs_to_active_hash :prefecture

end
