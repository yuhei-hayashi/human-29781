class ApplicationController < ActionController::Base
  before_action :basic_auth
  before_action :configure_permitted_parameters, if: :devise_controller?  
  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:user_name])
    devise_parameter_sanitizer.permit(:sign_in, keys: [ :user_name , :id])
  end

  def check_status(new_contract,temporary)
    contracts =temporary.contracts
    if new_contract.status_id != 1
      return
    else
    contracts.each do |contract|
      if contract.id != new_contract.id && contract.status_id == 1
        contract.status_id = 2
        contract.save
      end
    end
    end
  end

  def finish_contract(temporary)
    contracts = temporary.contracts
    contracts.each do |contract|
    if contract.status_id == 1
      return
    end
  end
  temporary.contract_status_id = 2
  temporary.save
  end

  def start_contract(contract,temporary)
    if contract.status_id == 1
        temporary.contract_status_id = 1
        temporary.save
    end
  end

  def check_contract(temporary)
    contracts = temporary.contracts
    if contracts.blank? && temporary.contract_status_id == 1
      finish_contract(temporary)
    else
      contracts.each do |contract|
        if contract.status_id == 1 && contract.finish_day < Date.today
          contract.status_id = 2
          contract.save
          finish_contract(temporary)
        elsif contract.status_id == 3 && contract.start_day <= Date.today
          contract.status_id = 1
          contract.save
          check_status(contract,temporary)
          start_contract(contract,temporary)
        end
      end
    end
  end

  def check_hire(temporary)
    if temporary.contract_status_id == 3 && temporary.hire_date <= Date.today
      temporary.contract_status_id = 2
      temporary.temporary_number = max_temporary_number
      temporary.save
    elsif temporary.contract_status_id != 3 && temporary.hire_date > Date.today
      temporary.contract_status_id = 3
      temporary.temporary_number = 0
      temporary.save
    end
  end

  def check_retirement(temporary)
    if temporary.contract_status_id == 4
      contracts = temporary.contracts
      contracts.each do |contract|
        contract.status_id = 2
        contract.save
      end
    end
  end

  def max_temporary_number
    if Temporary.maximum(:temporary_number) == nil
      return 1
    else
      return Temporary.maximum(:temporary_number) + 1
    end
  end

  def move_to_root
    redirect_to root_path unless user_signed_in?
  end

  def reservation_search_params
    params.fetch(:search, {}).permit(:full_name_reading, :temporary_number, :contract_status_id, :company_id, genre_id: [])
  end

  def get_week(meetings)
    @temporarys = Temporary.all
    wdays = ['(日)','(月)','(火)','(水)','(木)','(金)','(土)']
    @todays_date = Date.today
    @week_days = []
    plans = meetings.where(day: @todays_date..@todays_date + 6).order(:time)

    def check_wday(today)
      7.times do |i|
        check_sunday = today - i
        if check_sunday.strftime('%a') == "Sun"
          return i
        else 
        end
      end
    end

    7.times do |x|
      today_plans = []
      plan = plans.map do |plan|
        today_plans.push({time: plan.time.strftime("%H:%M"),company: plan.company_name, id: plan.id , temporary_id: plan.temporary_id}) if plan.day == @todays_date + x
      end
      days = { month: (@todays_date + x).month, date: (@todays_date+x).day, plans: today_plans, wday: wdays[check_wday(@todays_date + x)]}
      unless days[:wday] == '(日)' || days[:wday] == '(土)'
        @week_days.push(days) 
      end
      end
  end

  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV['BASIC_AUTH_USER'] && password == ENV['BASIC_AUTH_PASSWORD']
    end
  end

end
