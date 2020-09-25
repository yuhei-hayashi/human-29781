class Temporary < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  has_many :contracts, dependent: :destroy
  has_many :meetings, dependent: :destroy
  has_one :address , dependent: :destroy
  belongs_to_active_hash :genre
  belongs_to_active_hash :contract_status
  has_one_attached :resume, dependent: :destroy
  has_one_attached :skillsheet, dependent: :destroy

  scope :search, -> (search_params) do
    if search_params.blank?
    return
    else
    name_reading_like(search_params[:full_name_reading]).temporary_number(search_params[:temporary_number]).contract_status_id(search_params[:contract_status_id]).genre_id(search_params[:genre_id]).join_contract(search_params[:company_id]).company_id(search_params[:company_id]).status_id(search_params[:company_id])
    end
  end
  
  scope :join_contract, -> (company_id){joins(:contracts) if company_id.present?}
  scope :name_reading_like, -> (name_reading){where("full_name LIKE ? or full_name_reading LIKE ?","%#{name_reading}%","%#{name_reading}%") if name_reading.present?}
  scope :temporary_number, -> (temporary_number){where(temporary_number: temporary_number) if temporary_number.present?}
  scope :contract_status_id, -> (contract_status_id){where(contract_status_id: contract_status_id) if contract_status_id.present?}
  scope :genre_id, -> (genre_id){where(genre_id: genre_id) if genre_id.present? }
  scope :company_id, -> (company_id){where(contracts:{company_id: company_id}) if company_id.present?}
  scope :status_id, -> (company_id){where(contracts:{status_id: 1}) if company_id.present?}
end

