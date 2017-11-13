class LoginController < ApplicationController
  require 'digest/md5'

  def login
    user = User.find(email: login_params[:email], password: Digest::MD5.hexdigest(login_params[:password]))
    render status: :forbidden unless User.exists(user)
    token = generate_token
    user.update(token: token)
    render token
  end

  def register
    params = register_params
    token = generate_token
    params[:password] = Digest::MD5.hexdigest(params[:password])
    params[:token] = token
    user = User.new(params)
    if user.save
      render token, status: :created
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  def update
    user = User.find(token: user_params[:token])
    render status: :forbidden unless User.exists(user)
    if user.update(user_params)
      render status: :accepted
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  private
  def generate_token
    o = [('0'..'9'), ('a'..'z'), ('A'..'Z')].map(&:to_a).flatten
    (0...50).map { o[rand(o.length)] }.join
  end

  # Only allow a trusted parameter "white list" through.
  def register_params
    params.require(:user).permit(:name, :email, :password)
  end

  def login_params
    params.require(:user).permit(:email, :password)
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :token)
  end
end