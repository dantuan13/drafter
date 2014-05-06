class UsersController < ApplicationController
	skip_before_filter :require_login, only: [:new, :create]
  before_filter :find_user, only: [:profile, :account, :update_names, :password, :update_password]

  def new
  	@user = User.new
  end

  def make_user_dir(id)
    path = id.to_s
    dir_path =  Rails.root.join("public/users/")
    Dir.mkdir(dir_path + path)
    FileUtils.cp_r(dir_path + 'default_avatar.png', dir_path + path)
  end

  def create
  	@user = User.new(user_params)
    @user.avatar = "default_avatar.png"
    @user.gender = "1"
	  if @user.save
      make_user_dir(@user.id)
	    redirect_to root_url
	  else
	    render :new
	  end
  end

  def profile  
  end

  def account
  end

  def update_names
    @change_params  = update_names_params
    if @change_params[:avatar] != nil
      source = create_source(@change_params[:avatar], current_user.id.to_s)
      source_name = ("user_" + current_user.id.to_s + "_avatar." + source.format).delete(" ")
      @change_params[:avatar] = source_name
    end
    if @user.update @change_params
      if @change_params[:avatar] != nil
        source.write(Rails.root.join("public/users/" + current_user.id.to_s + "/" + source_name))
      end
      redirect_to account_path, :flash => { :success => "Дані успішно оновлено!"}
    else
      redirect_to account_path, :flash => { :alert => "Збій при оновленні!"}
    end
  end

  def create_source(picture, user_id)
    user_path = Rails.root.join("public/users/" + user_id + "/")
    File.open(user_path + picture.original_filename, 'wb') do |file|
       file.write(picture.read)
    end
    source = Magick::Image.read(user_path + picture.original_filename).first
    File.delete(user_path + picture.original_filename)
    source.resize_to_fit!(120)
  end

  def password
  end

  def update_password
    @check_data = update_password_params
    if @check_data[:password].length > 7 && @check_data[:password] == @check_data[:password_confirmation]
        if @user.update @check_data
          redirect_to password_path, :flash => { :success => "Дані успішно оновлено!"}
        else
          redirect_to password_path, :flash => { :alert => "Збій при оновленні!"}
        end
    else
      redirect_to password_path, :flash => { :alert => "Кароткий пароль, або поля не співпадають!"}
    end
  end


 private

  def find_user
    @user = current_user
  end

  def update_password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def update_names_params
    params.require(:user).permit(:email, :login, :avatar, :gender)
  end

  def user_params
    params.require(:user).permit(:login, :email, :password, :password_confirmation)
  end

end
