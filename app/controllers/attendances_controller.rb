class AttendancesController < ApplicationController
  before_filter :signed_in_user
  before_filter :is_a_student, :only =>[:new, :create, :update]

  def new
    @attendance = Attendance.where(user: current_user, attended_on: Date.today).first() || Attendance.new
  end

  # Create a new attendance
  def create
    @attendance = Attendance.new(attendance_params)
    
    if @attendance.save
      redirect_to chart_path, notice: "You have logged your attendance!"
    else
      flash.now[:alert] = "Select a seat"
      render "new"
    end
  end

  # Update the current attendance base on the current day and the user
  def update
    @attendance = Attendance.where(user: current_user, attended_on: Date.today).first()
    if @attendance.update(attendance_params)
      redirect_to chart_path, notice: "You have logged your attendance!"
    else
      flash.now[:alert] = "Select a seat"
      render 'new'
    end
    #end
  end
  
  # 
  def index
    @attendances = Attendance.all.order(created_at: :desc)
  end
  
  # Show all the attendances
  def seating_chart
    @attendances = {}
    @current_date = params[:date] ? Date.parse(params[:date]) : Date.today
    @attendances_records = Attendance.where(attended_on: @current_date).order(created_at: :asc)
    @student_ids = @attendances_records.map(&:user_id)

    # Group students by seat number
    @attendances_records.each do |attendance| 
      @attendances[attendance.seat] ||= []
      @attendances[attendance.seat].push(attendance)
    end

    @absent_students = (@student_ids.empty?) ? User.get_all_students :
      User.find(:all, :conditions => ['id not in (?)', @student_ids])

    render 'chart'
  end

  # Show the attendance for a particular student 
  def show
    @user = User.find(params[:id])
    @attendance = @user.attendances.order(created_at: :desc);
  end

  private
    def attendance_params
      params.require(:attendance).permit(:seat)
    end

    # Redirects to `signin_path` if the user hasn't signed in yet
    def signed_in_user
      redirect_to signin_path, :status => 302 unless signed_in?
    end

    def is_a_student
      redirect_to root_path, :status => 302, :alert => 'Unathorized Access' unless current_user.is_student?
    end
end
