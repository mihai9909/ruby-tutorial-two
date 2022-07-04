class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update] # Check if request expired

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      send_reset_mail
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty? # Empty password case
      @user.errors.add(:password, "can't be empty")
      render 'edit'
    elsif @user.update(user_params) # Success case
      log_in @user
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = "Password has been reset."
      redirect_to @user
    else  # Invalid password case
      render 'edit' 
    end
  end
    
  private
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    # Sends request to emailjs API to send a password reset email to the user
    def send_reset_mail
      response = HTTPX.post("https://api.emailjs.com/api/v1.0/email/send", :json => {'service_id' => 'default_service',
      'template_id' => 'template_eitmj18',
      'user_id' => 'RLpsZfhP-QdAf11kA',
      'template_params' => {'to_email' => @user.email, 'message' => edit_password_reset_url(@user.reset_token, email: @user.email), 'to_name' => @user.name},
      'accessToken' => ENV['EMAILJS_API_KEY'] 
      })
    end

    def get_user
      @user = User.find_by(email: params[:email])
    end

    # Confirms a valid user.
    def valid_user
      unless (@user && @user.activated? &&
              @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end

    # Checks expiration of reset token.
  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = "Password reset has expired."
      redirect_to new_password_reset_url
    end
  end
end
