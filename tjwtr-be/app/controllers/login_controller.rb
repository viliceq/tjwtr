class LoginController < ApplicationController
  require 'digest/md5'

  def login
    user = User.where(email: login_params[:email], password: Digest::MD5.hexdigest(login_params[:password]))
    unless User.exists?(user)
      render status: :forbidden
      return
    end
    token = generate_token
    user.update(token: token)
    render plain: token
  end

  def register
    params = register_params
    token = generate_token
    params[:password] = Digest::MD5.hexdigest(params[:password])
    params[:token] = token
    user = User.new(params)
    if user.save
      render plain: token, status: :created
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  def update
    params = user_params
    params[:password] = Digest::MD5.hexdigest(params[:password]) if params[:password]
    user = User.where(token: params[:token])
    unless User.exists?(user)
      render status: :forbidden
      return
    end
    if user.update(params)
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
    params.permit(:name, :email, :password)
  end

  def login_params
    params.permit(:email, :password)
  end

  def user_params
    params.require(:token)
    params.permit(:name, :email, :password, :token)
  end
end
