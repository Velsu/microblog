class UsersController < ApplicationController
  def new
  end

  def show
  	@user = User.find(params[:id])
  end

  def new
  	@user = User.new
  end

  def create
  	@user = User.new(valid_params)
  	if @user.save
      log_in @user
  		flash[:success] = "Welcome to Microblog App"
  		redirect_to @user
  	else
  		render 'new'
  	end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(valid_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end





  private

  def valid_params
  	params.require(:user).permit(:name, :email, :password,
  								:password_confirmation)
  end
end
