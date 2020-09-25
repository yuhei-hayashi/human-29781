class CompaniesController < ApplicationController
  before_action :move_to_root
  before_action :find_company , only: [:show , :edit , :update , :destroy]

  def new
    @company = Company.new
  end

  def create
    @company = Company.new(company_params)
    if @company.valid?
      @company.save
      redirect_to companies_path
    else
      render :new
    end
  end

  def index
    @companies = Company.includes(:contracts)
  end

  def show
    @contracts = @company.contracts.includes(:user , :temporary)
    @status = number_company(@contracts)
  end

  def edit
  end

  def update
    if @company.update(company_params)
      redirect_to company_path(@company.id)
    else
      render :edit
    end
  end

  def destroy
    if @company.destroy
      redirect_to companies_path
    else
      redirect_to company_path(@company.id)
    end
  end

  private

  def company_params
    params.require(:company).permit(:name, :annual_sales, :capiral, :hp)
  end

  def number_company(contracts)
    number = {}
    number[:contracts_count] = contracts_count(contracts)
    number[:average_prices] = average_prices(contracts)
    number[:contracts_allcount] = contracts_allcount(contracts)
    number
  end

  def contracts_count(contracts)
    contract_count = 0
    contracts.each do |contract|
      if contract.status_id == 1
         contract_count += 1
      end 
    end 
    contract_count
  end

  def average_prices(contracts)
    sum = 0
    contracts.each_with_index do |contract|
      if contract.status_id == 1
      sum += contract.price
      end
    end
    if contracts_count(contracts) != 0
    sum / contracts_count(contracts)
    else
      sum
    end
  end

  def contracts_allcount(contracts)
    contract_count = 0
    contracts.each do |contract|
         contract_count += 1
    end 
    contract_count
  end

  def find_company
    @company = Company.find(params[:id])
  end
end
