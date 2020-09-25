class TemporaryAddress
  include ActiveModel::Model
  attr_accessor :full_name, :full_name_reading , :temporary_number , :birthday , :hire_date , :genre_id , :contract_status_id , :telephone , :mail ,:post_code , :prefecture_id , :city , :house_number , :building_name , :resume , :skillsheet

  with_options presence: true do
    NAME_REGEX = /\A[ぁ-んァ-ン一-龥]/.freeze
    validates :full_name ,format: { with: NAME_REGEX, message: 'is invalid. Input full-width characters.' }
    NAME_READING_REGEX = /\A[ァ-ヶー－]+\z/.freeze
    validates :full_name_reading , format: { with: NAME_READING_REGEX, message: 'is invalid. Input full-width katakana characters.'}
    validates :birthday
    validates :hire_date
    validates :genre_id
    validates :contract_status_id
    TELEPHONE_REGEX = /\A\d{11}\z/.freeze
    validates :telephone ,  format: { with: TELEPHONE_REGEX }
    validates :mail
    POSTCODE_REGEX = /\A\d{3}[-]\d{4}\z/.freeze
    validates :post_code ,format: { with: /\A\d{3}[-]\d{4}\z/ }
    validates :prefecture_id
    validates :city
    validates :house_number
  end
  validates :temporary_number , presence: true

  def save
    temporary = Temporary.create(full_name: full_name, full_name_reading: full_name_reading, temporary_number: temporary_number, birthday: birthday, hire_date: hire_date, genre_id: genre_id, contract_status_id: contract_status_id, telephone: telephone, mail: mail, resume: resume, skillsheet: skillsheet )
    Address.create(post_code: post_code, prefecture_id: prefecture_id, city: city, house_number: house_number, building_name: building_name, temporary_id: temporary.id)
  end

end