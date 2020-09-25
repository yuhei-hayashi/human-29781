class Meeting < ApplicationRecord
  belongs_to :user
  belongs_to :temporary

  with_options presence: true do
    validates :day
    validates :company_name
    validates :time
  end
end
