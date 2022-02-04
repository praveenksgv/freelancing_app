class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @request = Request.new
      if current_user.role == 1
        if params[:specialization] && !params[:specialization].blank? 
            a = Job.select{ |job| job.skills.include?(params[:specialization].strip.upcase) && job.requests.where("user_id == ?", current_user.id).count == 0}
            b = Job.where(id: a.map(&:id))
            @jobs = b.where("state = ?", 2).paginate(page: params[:page])
            if @jobs.count == 0
              flash[:info] = 'No availabel jobs for you, according to the skill you searched for!'
            end
        else 
          specializations = current_user.specializations.pluck(:name)
          a = Job.select { |job| specializations.any? { |str| job.skills.include? str } }
          b = a.select{ |job| job.requests.where("user_id = ?", current_user.id).count==0 }
          @jobs = Job.where(id: b.map(&:id))
          @jobs = @jobs.where("state = ?", 2).paginate(page: params[:page])
          if @jobs.count == 0
            # flash[:info] = "No available job for you, that matches your experties!"
            a = Job.select{ |job| job.requests.where("user_id == ?", current_user.id).count == 0}
            @jobs = Job.where(id: a.map(&:id))
            @jobs = @jobs.where("state = ?", 2)
          end
        end
      else 
        @jobs = current_user.jobs.where("state != ?", 0).paginate(page: params[:page])
      end
    end
  end

  def howitworks 
    
  end

  def about
  end
  
  def contact
  end

end
