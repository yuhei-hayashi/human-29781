class TemporarysController < ApplicationController
  before_action :move_to_root ,except: :index
  before_action :find_temporary , only: [:show, :edit, :update, :destroy]
  before_action :find_address , only: [:show, :edit, :update]
  before_action :set_temporary_address , only: [:new, :edit]

  def index
    @temporarys = Temporary.includes(:address)
    check_contracts(@temporarys)
    check_hires(@temporarys)
    check_retirements(@temporarys)
  end

  def search
    @search_params = reservation_search_params
    @temporarys = Temporary.search(@search_params).uniq
    check_contracts(@temporarys)
    check_hires(@temporarys)
    check_retirements(@temporarys)
  end

  def new
  end

  def create
    @temporary_address = TemporaryAddress.new(new_temporary_number)
    if @temporary_address.valid?
      @temporary_address.save
      move_new_contract(Temporary.all.order(id: "DESC").first)
    else
      render :new
    end
  end

  def show
    @contracts = @temporary.contracts.order(id: "DESC")
    check_contract(@temporary)
    check_hire(@temporary)
    check_retirement(@temporary)
    meetings = @temporary.meetings
    get_week(meetings)
  end

  def edit
  end

  def update
    @temporary_address = TemporaryAddress.new(new_temporary_number)
    if @temporary_address.valid?
      @temporary.update(temporary_only_params)
      @address.update(address_only_params)
      redirect_to temporary_path(@temporary.id)
    else
      render :edit
    end
  end

  def destroy
    if @temporary.destroy
      redirect_to root_path
    else
      render :show
    end
  end

  private

  def temporary_params
    params.permit(:full_name, :full_name_reading, :genre_id, :contract_status_id, :telephone , :mail , :post_code , :prefecture_id,:city , :house_number, :building_name, :resume, :skillsheet).merge(birthday: birthday ,hire_date: hire_date)
  end
  
  def temporary_only_params
    params.permit(:full_name, :full_name_reading, :genre_id, :contract_status_id, :telephone , :mail , :resume, :skillsheet).merge(birthday: birthday ,hire_date: hire_date, temporary_number: Temporary.find(params[:id]).temporary_number)
  end

  def address_only_params
    params.permit( :post_code , :prefecture_id,:city , :house_number, :building_name)
  end
  def birthday
    Date.new(params.require("birthday(1i)").to_i,params.require("birthday(2i)").to_i,params.require("birthday(3i)").to_i) rescue nil
  end

  def hire_date
    Date.new(params.require("hire_date(1i)").to_i,params.require("hire_date(2i)").to_i,params.require("hire_date(3i)").to_i) rescue nil
  end

  def new_temporary_number
    if temporary_params[:contract_status_id].to_i == 3
      temporary_params.merge(temporary_number: 0)
    else
      temporary_params.merge(temporary_number: max_temporary_number)
    end 
  end

  def find_temporary
    @temporary = Temporary.find(params[:id])
  end

  def find_address
    @address = @temporary.address
  end

  def set_temporary_address
    @temporary_address = TemporaryAddress.new
  end

  def check_contracts(temporarys)
    temporarys.each do |temporary|
      check_contract(temporary)
    end
  end

  def check_hires(temporarys)
    temporarys.each do |temporary|
      check_hire(temporary)
    end
  end

  def check_retirements(temporarys)
    temporarys.each do |temporary|
      check_retirement(temporary)
    end
  end

  def move_new_contract(temporary)
    if temporary.contract_status_id == 1
      redirect_to new_temporary_contract_path(temporary.id)
    else
      redirect_to root_path
    end
  end
end
