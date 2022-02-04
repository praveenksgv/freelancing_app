module SessionsHelper
    def log_in(user)
        session[:user_id] = user.id 
        session[:session_token] = user.session_token
    end

    def remember(user)
        user.remember
        cookies.permanent.encrypted[:user_id] = user.id
        cookies.permanent[:remember_token] = user.remember_token
    end

#It provides the currently signed in user in the variable @current_user

    def current_user 
        if(user_id = session[:user_id])
            user = User.find_by(id: user_id)
            if user && session[:session_token] == user.session_token
                @current_user = user
            end
        elsif (user_id = cookies.encrypted[:user_id])
            user = User.find_by(id: user_id)
            if user && user.authenticated?(:remember, cookies[:remember_token])
                log_in user
                @current_user = user;
            end
        end
    end

#Returns true if the given user is the current user

    def current_user?(user)
        user && user == current_user
    end

#Returns true if someone is logged into the website

    def logged_in?
        !current_user.nil?
    end

#It will delete the remember_me functionality
    
    def forget(user)
        user.forget
        cookies.delete(:user_id)
        cookies.delete(:remember_token)
    end

#It will log_out the user from website

    def log_out
        forget(current_user)
        reset_session
        @current_user = nil
    end

#Stores the URL, user trying to access.

    def store_location
        session[:forwarding_url] = request.original_url if request.get?
    end

end
