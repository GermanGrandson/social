class SessionsController < ApplicationController
  def new
  end

  def create
     user = User.find_by(email:params[:session][:email].downcase)
     if
       user && user.authenticate(params[:session][:password])
       log_in user
       params[:session][:remember_me] == '1' ? remember(user) : forget(user) #Note below
       redirect_to user
       # Log the user in and redirect to the user's show page
     else
       # Creates an error message
       flash.now[:danger] = "Invalid Email/Password Combination" #Error Flash Message
       render 'new'
     end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

end

# Line is refactored to state the below
# if params[:session][:remember_me] == '1'
#   remember(user)
# else
#   forget(user)
# end
