class Company < ApplicationRecord
  has_many :contracts , dependent: :destroy

  with_options presence: true do
    validates :name
    validates :annual_sales
    validates :capiral
  end
end
