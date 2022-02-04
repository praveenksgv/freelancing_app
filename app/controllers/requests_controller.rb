class RequestsController < ApplicationController
    before_action :logged_in_user, only: [:invitations, :applications, :create, :destroy, :update]
    before_action :correct_user_for_create, only: :create
    before_action :correct_user_for_destroy, only: :destroy
    before_action :correct_user_for_update, only: :update


    def create 
        @request = Request.new(request_params)
        if @request.job.state == 0
            flash[:info] = "Already hired for this job";
            redirect_to root_url 
            return 
        end 

        if @request.status == "Denied"
            session[:request] = @request 
            redirect_to users_url
            return 
        end
        session[:request] = nil
        if @request.save 
            flash[:success] = 'Request sent successfully'
            redirect_to root_url
        else
            flash[:danger] = 'Already Requested!'
            redirect_to root_url
        end
    end
    def destroy 
        @request = Request.find(params[:id])
        @request.destroy
        flash[:danger] = 'Request Deleted'
        redirect_to request.referrer 
    end
    def update 
        @request = Request.find(params[:id])
        if @request.job.state == 0
            flash[:info] = "Hiring is done for this job"
            redirect_to root_url
            return 
        end
        @request.update(request_params)
        if @request.status == "Accepted"
            job = @request.job
            job.state = 0
            job.save 
        end
        redirect_to request.referrer
    end

    def applications
        if current_user.role ==1
            if params[:application].nil? || params[:application][:id].empty?
                @requests = current_user.requests.where("method = ?", "Application").paginate(page: params[:page])
                a = current_user.requests.where("method = ?", "Application")
                @jobs = Job.select{ |job| a.any?{ |request| job == request.job}}
            else 
                a = current_user.requests.where("method = ?", "Application")
                b=a.select{ |request| request.job.id == params[:application][:id].to_i }
                @requests = Request.where(id: b.map(&:id)).paginate(page: params[:page])
                @jobs = Job.select{ |job| a.any?{ |request| job == request.job}}
            end 
        else 
            if params[:application].nil? || params[:application][:id].empty? 
                a = Request.where("method = ?", "Application") 
                b = a.select{ |request| request.job.user == current_user }
                @requests = Request.where(id: b.map(&:id)).paginate(page: params[:page])
                @jobs = current_user.jobs.where("state != ?", 1)
            else    
                a = Request.where("method = ?", "Application") 
                b = a.select{ |request| request.job.id == params[:application][:id].to_i }
                @requests = Request.where(id: b.map(&:id)).paginate(page: params[:page])
                @jobs = current_user.jobs.where("state != ?", 1)
            end
        end
    end
    def invitations 
        if current_user.role ==1
            if params[:invitation].nil? || params[:invitation][:id].empty?
                @requests = current_user.requests.where("method = ?", "Invitation").paginate(page: params[:page])
                a = current_user.requests.where("method = ?", "Invitation")
                @jobs = Job.select{ |job| a.any?{ |request| job == request.job}}
            else 
                a = current_user.requests.where("method = ?", "Invitation")
                b=a.select{ |request| request.job.id == params[:invitation][:id].to_i }
                @requests = Request.where(id: b.map(&:id)).paginate(page: params[:page])
                @jobs = Job.select{ |job| a.any?{ |request| job == request.job}}
            end 
        else 
            if params[:invitation].nil? || params[:invitation][:id].empty? 
                a = Request.where("method = ?", "Invitation") 
                b = a.select{ |request| request.job.user == current_user }
                @requests = Request.where(id: b.map(&:id)).paginate(page: params[:page])
                @jobs = current_user.jobs 
            else    
                a = Request.where("method = ?", "Invitation") 
                b = a.select{ |request| request.job.id == params[:invitation][:id].to_i }
                @requests = Request.where(id: b.map(&:id)).paginate(page: params[:page])
                @jobs = current_user.jobs
            end
        end
    end

    
    private 
        def request_params
            params.require(:request).permit(:job_id, :user_id, :status, :method)
        end


        def correct_user_for_create
           @request = Request.new(request_params)
           if @request.method == "Invitation"
                if !current_user?(@request.job.user)
                    redirect_to root_url
                end
           else 
                if !current_user?(@request.user)
                    redirect_to root_url
                end
           end
        end
        def correct_user_for_destroy
            @request = Request.find(params[:id])
            if @request.method == "Invitation"
                if current_user?(@request.job.user)
                    return true
                else
                    redirect_to root_url
                end
            else
                if current_user?(@request.user)
                    return true
                else 
                    redirect_to root_url
                end
            end
        end

        def correct_user_for_update
            # @request = Request.find(params[:id])
            # if @request.method == "Invitation"
            #     if !current_user?(@request.user)
            #         redirect_to root_url
            #     end
            # else
            #     if !current_user?(@request.job.user)
            #         redirect_to root_url
            #     end
            # end
        end
end
