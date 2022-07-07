class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy


  def new
    @user = User.new
  end



  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def show
    if (aux_user = User.find(params[:id])) && aux_user.activated?
      @user = aux_user
      @microposts = @user.microposts.paginate(page: params[:page])
    else
      flash[:warning] = 'User hasn\'t activated his account'
      redirect_to root_url
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # @user.send_activation_email
      send_activation_mail
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_update_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted successfully"
    redirect_to users_url
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])  
    render 'show_follow'
  end

  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    # can update only the name and password
    def user_update_params
      params.require(:user).permit(:name, :password, :password_confirmation)
    end

    # Before filters

    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    
    # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

    # Sends request to emailjs API to send a confirmation email to the user
    def send_activation_mail
      response = HTTPX.post("https://api.emailjs.com/api/v1.0/email/send", :json => {'service_id' => 'default_service',
      'template_id' => 'template_5eqjt4j',
      'user_id' => 'RLpsZfhP-QdAf11kA',
      'template_params' => {'to_email' => @user.email, 'message' => edit_account_activation_url(@user.activation_token, email: @user.email), 'to_name' => @user.name},
      'accessToken' => ENV['EMAILJS_API_KEY']
      })
    end
end
