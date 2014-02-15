class AttendancesController < ApplicationController
  before_filter :signed_in_user

  def new
    @attendance = Attendance.where(user: current_user, attended_on: Date.today).first() || Attendance.new
  end

  # Create a new attendance
  def create
    params = attendance_params;
    @attendance = Attendance.new(params)

    # The student hasn't chosen a seat
    if (params[:seat].nil? || params[:seat].empty?)
      flash.now[:alert] = 'Select a seat'
      render 'new'
    else
      # Create a new attedance
      @attendance.attended_on = Date.today;
      @attendance.user = current_user

      if @attendance.save
        redirect_to attendances_path, notice: "You have logged your attendance!"
      else
        render 'new'
      end
    end
  end

  # Update the current attendance base on the current day and the user
  def update
    params = attendance_params;

    # If the user unselected the seat, remove the current seat
    if (params[:seat].nil? || params[:seat].empty?)
      @attendance = Attendance.where(user: current_user, attended_on: Date.today).first()
      if @attendance.destroy()
        redirect_to attendances_path, notice: "You have removed your attendance!"
      else
        render 'new'
      end
    else 
      # Find the current attendance and update it
      @attendance = Attendance.where(user: current_user, attended_on: Date.today).first()
      if @attendance.update(attendance_params)
        redirect_to attendances_path, notice: "You have logged your attendance!"
      else
        render 'new'
      end
    end
  end
  
  # Show all the attendances
  def index
    @attendances = Attendance.all.order(created_at: :desc)
  end

  private
    def attendance_params
      params.require(:attendance).permit(:seat)
    end

    # Redirects to `signin_path` if the user hasn't signed in yet
    def signed_in_user
      redirect_to signin_path, :status => 403, :flash => {:error => "Please sign in."} unless signed_in?
    end
end
