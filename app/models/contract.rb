class Contract < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :status
  belongs_to :company
  belongs_to :temporary
  belongs_to :user

  with_options presence: true do
    validates :start_day
    validates :finish_day
    validates :price
  end

  validate :start_finish_check

  def start_finish_check
    errors.add(:finish_date, "Is Invalid") unless
    self.start_day < self.finish_day
  end


end
