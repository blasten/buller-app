class AssignmentsController < ApplicationController
  before_filter :signed_in_user
  before_filter :is_admin, :only =>[:new, :create, :update]
  before_filter :is_student, :only =>[:show]

  def new
    @assignment = Assignment.new
    @students = User.get_all_students
    @current_student = params[:student]
  end

  def create
    @assignment = Assignment.new(assignment_params)
    @students = User.get_all_students
    @current_student = @assignment.user_id

    if @assignment.save
      redirect_to users_path, notice: "You have created a assignment!"
    else
      render "new"
    end
  end

  def index
    if current_user.is_student?
      @assignments = current_user.assignments.order(created_at: :desc)
      render "student_index"
    elsif current_user.is_admin?
      @current_student = params[:student]
      @students = User.get_all_students
      @average_grade = 0
      if @current_student.nil? || @current_student.empty?
        @average_grade = Assignment.average_percentage
        @assignments = Assignment.all.order(created_at: :desc)
      else
        @average_grade = User.find(@current_student).current_grade
        @assignments = Assignment.where(user_id: @current_student).order(created_at: :desc)
      end
      render "admin_index"
    end
  end

  private
    def assignment_params
      params.require(:assignment).permit(:user_id, :name, :score, :total)
    end

    def is_admin
      redirect_to root_path, :status => 302, :alert => "Unathorized Access" unless current_user.is_admin?
    end

    def is_student
      redirect_to root_path, :status => 302, :alert => "Unathorized Access" unless current_user.is_student?
    end
    
    # Redirects to `signin_path` if the user hasn't signed in yet
    def signed_in_user
      redirect_to signin_path, :status => 302 unless signed_in?
    end
end
