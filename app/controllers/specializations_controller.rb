class SpecializationsController < ApplicationController
    before_action :logged_in_user, only: [:create, :destroy]
    before_action :is_freelancer, only: :create
    before_action :correct_user_for_destroy, only: :destroy 

    def create 
        @specialization = current_user.specializations.build(specialization_params)
        @specialization.name.upcase!
        @specialization.name.strip!
        if @specialization.save
            flash[:success] = "Specialization added to your profile"
        else 
            flash[:danger] = "Invalid / Already added specialization"
        end
        redirect_to user_url(current_user)
    end

    def destroy 
        specialization = Specialization.find_by(id: params[:id])
        if specialization.present?
            specialization.destroy 
            flash[:success] = "Specialization deleted"
        end
        redirect_to user_url(current_user)
    end


    private 
        def specialization_params
            params.require(:specialization).permit(:name)
        end
        def is_freelancer
            if current_user.role == 0
                flash[:danger] = "This action is for freelancer's only"
                redirect_to root_url
            end
        end
        def correct_user_for_destroy
            specialization = Specialization.find_by(id: params[:id])
            if !specialization.nil?
                if  !current_user?(specialization.user)
                    flash[:danger] = "You are not correct user for this action!"
                    redirect_to root_url
                end 
            end
        end

end
