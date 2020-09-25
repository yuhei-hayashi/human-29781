class MeetingsController < ApplicationController
  before_action :move_to_root
  before_action :find_meeting , only: [:edit , :update , :destroy]
  before_action :find_temporary , only: [:new , :create , :edit , :update , :destroy]
  before_action :define_week_day, only: [:new , :create , :edit , :update]

  def index
    @meetings = Meeting.includes(:user,:temporary).order(day: :desc).order(time: :desc)
    get_week(@meetings)
  end

  def new
    @meeting = Meeting.new
  end

  def create
    @meeting = Meeting.new(meeting_params)
    if @meeting.valid?
      @meeting.save
      redirect_to meetings_path
    else
      render :new
    end
  end

  def search
    @search_params = reservation_search_params
    @temporarys = Temporary.search(@search_params).uniq
  end

  def edit
  end

  def update
    if @meeting.update(meeting_params)
      redirect_to meetings_path
    else
      render :edit
    end
  end

  def destroy
    if @meeting.destroy
      redirect_to meetings_path
    else
      redirect_to meetings_path(anchor: @meeting.id)
    end
  end

  private

  def meeting_params
    params.require(:meeting).permit(:company_name).merge(day: day,time: time, temporary_id: params[:temporary_id],user_id: current_user.id)
  end

  def day
    Date.new(params.require(:meeting).require("date(1i)").to_i,params.require(:meeting).require("date(2i)").to_i,params.require(:meeting).require("date(3i)").to_i) rescue nil
  end

  def time
    DateTime.new(params.require(:meeting).require("time(1i)").to_i,params.require(:meeting).require("time(2i)").to_i,params.require(:meeting).require("time(3i)").to_i,params.require(:meeting).require("time(4i)").to_i,params.require(:meeting).require("time(5i)").to_i) rescue nil
  end

  def find_temporary
    @temporary = Temporary.find(params[:temporary_id])
  end

  def find_meeting
    @meeting = Meeting.find(params[:id])
  end

  def define_week_day
    meetings = @temporary.meetings
    get_week(meetings)
  end

end
