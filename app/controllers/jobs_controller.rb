class JobsController < ApplicationController
  include SessionsHelper
  before_action :logged_in_user, only: [:new, :index, :edit, :update, :destroy]
  before_action :current_user_client, only: [:new, :create]
  before_action :correct_user, only: [:edit, :update, :destroy]
  # before_action :correct_user_for_show, only: :show

  def new
      @job = current_user.jobs.build 
  end


  def create
    @job = current_user.jobs.build(job_params)
    if @job.save 
      flash[:success] = "Job created!"
      redirect_to root_url
    else  
      render 'jobs/new'
    end 
  end


  def show
    @job = Job.find(params[:id])
    if current_user.role == 1
      if @job.requests.where("user_id = ? AND method = ? AND status = ?", current_user.id, "Invitation", "Pending").count == 1 && @job.state != 0
        @request = @job.requests.where("user_id = ? AND method = ?", current_user.id, "Invitation")
      else 
        @request = current_user.requests.build 
      end 
    end
  end

  
  def edit
    @job = Job.find(params[:id])
  end

  def update 
    @job = Job.find(params[:id])
    if @job.update(job_params)
      flash[:success] = 'Job Updated'
      redirect_to job_url(@job)
    else
      render 'edit'
    end
  end

  def destroy 
    @job = Job.find(params[:id])
    if @job.destroy
      flash[:success] = "Job deleted"
      redirect_to root_url
    end
  end

  private

    def job_params
      params.require(:job).permit(:title, :description, :state, :budget, :skills)
    end

    def current_user_client
      if current_user.role == 1
        flash[:info] = 'This function is exclusive to client users only'
        redirect_to root_url
      end
    end

    # def correct_user_for_show
    #   if !current_user.role == 1 && !current_user?(current_user)
    #     flash[:danger] = "You are not supposed to look at other client's job"
    #     redirect_to root_url
    #   end
    # end

    def correct_user
      @job = Job.find(params[:id])
      if !current_user?(@job.user)
        flash[:danger] = "Not authorised to manipulate other client's job"
        redirect_to root_url
        return 
      end
      if @job.requests.count != 0
        flash[:info] = "This job cannot be manipulated, becauser it does have invitations/applications !"
        redirect_to root_url
        return 
      end
    end

end
