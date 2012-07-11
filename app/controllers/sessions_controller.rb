class SessionsController < ApplicationController
  def new
  end

 def create

        omniauth = request.env["omniauth.auth"]

        unless omniauth
            redirect_to authentications_url
            flash[:notice] = "Could not authenticate via #{params['provider']}."
        end

        authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
        if authentication
            flash[:notice] = "Signed in successfully."
            sign_in_and_redirect(:user, authentication.user)
        elsif current_user

            current_user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'], :token => omniauth['credentials']['token'], :secret => omniauth['credentials']['secret'])
            flash[:notice] = "Authentication successful."
            redirect_to authentications_url
        else
            user = User.new
            user.apply_omniauth(omniauth)
            if user.save
                flash[:notice] = "Signed in successfully."
                sign_in_and_redirect(:user, user)
            else
                session[:omniauth] = omniauth.except('extra')
                redirect_to new_user_registration_url
            end
        end
    end



  def failure
  render :text => "Sorry, but you didn't allow access to our app!"
end

  def destroy
  session[:user_id] = nil
  render :text => "You've logged out!"
end

end
