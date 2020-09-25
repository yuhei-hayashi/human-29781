class ContractsController < ApplicationController
  before_action :move_to_root
  before_action :find_contract , except: [:new , :create]
  before_action :find_temporary

  def new
    @contract = Contract.new
  end

  def create
    @contract = Contract.new(contract_params)
    if @contract.valid?
      @contract.save
      check_status(@contract,@temporary)
      start_contract(@contract,@temporary)
      redirect_to temporary_path(@temporary.id)
    else
      render :new
    end
  end

    def edit
    end

    def update
      if params[:submit] == "編集"
        @contract.update(contract_params)
        check_status(@contract,@temporary)
        start_contract(@contract,@temporary)
        finish_contract(@temporary)
        redirect_to temporary_path(@temporary.id)
      else
        contract = Contract.new(contract_params)
        if contract.valid?
          contract.save
          check_status(contract,@temporary)
          start_contract(contract,@temporary)
          redirect_to temporary_path(@temporary.id)
        else
          render :edit
        end
      end
    end

    def destroy
      if @contract.destroy
        finish_contract(@temporary)
        redirect_to temporary_path(@temporary.id)
      else
        redirect_to temporary_path(@temporary.id)
      end
    end

  private

  def contract_params
    params.require(:contract).permit(:company_id, :price, :status_id , :user_id, :task_name).merge(start_day: start_day, finish_day: finish_day , temporary_id: params[:temporary_id])
  end
  def start_day
      Date.new(params.require(:contract).require("start_day(1i)").to_i,params.require(:contract).require("start_day(2i)").to_i,params.require(:contract).require("start_day(3i)").to_i) rescue nil
  end

  def finish_day
    Date.new(params.require(:contract).require("finish_day(1i)").to_i,params.require(:contract).require("finish_day(2i)").to_i,params.require(:contract).require("finish_day(3i)").to_i) rescue nil
  end

  def find_contract
    @contract = Contract.find(params[:id])
  end

  def find_temporary
    @temporary = Temporary.find(params[:temporary_id])
  end

end
