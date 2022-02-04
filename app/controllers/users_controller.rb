class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy]
  before_action :correct_user_for_index, only: :index 
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy 
  # before_action :choice_should_be_given, :choices

  def index
      if session[:request].nil?
          flash[:info] = "To send invitation first select a job to invite!"
          redirect_to root_url
      end
      @request = Request.new(session[:request])
      if params[:user] && !params[:user].blank?
          a = User.select { |user| user.name.upcase.include?(params[:user].strip.upcase) }
          @users = User.where(id: a.map(&:id))
          @users = @users.where("role = ?", 1).paginate(page: params[:page])
          if @users.count == 0
            flash.now[:info] = "No match for the name you search!"
          end 
      else 
          @users = User.where("role = 1").paginate(page: params[:page])
      end
  end
  
  def destroy 
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  def new
    @user = User.new
  end

  def show 
      @user = User.find(params[:id])
      if @user.role == 1
        @specializations = @user.specializations.paginate(page: params[:page])
        if current_user?(@user)
          @specialization = current_user.specializations.build 
        end
        @requests = @user.requests.where("status = ?", "Accepted").paginate(page: params[:page])
      else
        a = Request.select{ |request| request.job.user == @user && request.status == "Accepted" }
        @requests = Request.where(id: a.map(&:id)).paginate(page: params[:page])
      end
  end

  def create 
    @user = User.new(user_params)
    if @user.save
      reset_session
      log_in @user
      flash[:success] = "Welcome to the Freelancing App!"
      redirect_to @user
      # @user.send_activation_email
      # flash[:info] = "Please check your email to activate your account."
      # redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update 
    @user = User.find(params[:id])

    if @user.update(user_params)
      if @user.description.length > 50
        @user.description = @user.description[0...50]
        @user.save 
      end
      flash[:success] = "Profile updated"
      redirect_to @user
    else  
      render 'edit'
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :role, :password, :password_confirmation,:description)
    end


    def correct_user
      @user = User.find(params[:id])
      if !current_user?(@user) 
        flash[:danger] = "You are not authorised to edit other user's information!"
        redirect_to root_url
      end
    end
    
    def correct_user_for_index
      if current_user.role == 1
        flash[:danger] = "This page is reserved for client users only!"
        redirect_to root_url
      end
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

end


# def following 
  #   @title = "Following"
  #   @user = User.find(params[:id])
  #   @users = @user.following.paginate(page: params[:page])
  #   render 'show_follow'
  # end

  # def followers 
  #   @title = "Followers"
  #   @user = User.find(params[:id])
  #   @users = @user.followers.paginate(page: params[:page])
  #   render 'show_follow'
  # end