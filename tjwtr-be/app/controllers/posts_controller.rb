class PostsController < ApplicationController
  before_action :set_post, only: [:show, :update, :destroy]

  # GET /posts
  def index
    @posts = Post.all
    render json: @posts
  end

  # GET /posts/1
  def show
    render json: @post
  end

  # POST /posts
  def create
    user = User.where(token: post_params[:token])
    unless User.exists?(user)
      render status: :forbidden
      return
    end
    @post = Post.new(content: post_params[:content], user: user)

    if @post.save
      render json: @post, status: :created, location: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/1
  def update
    unless post_params[:token] === @post.user.token
      render status: :forbidden
      return
    end
    if @post.update(content: post_params[:content])
      render json: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1
  def destroy
    unless post_params[:token] === @post.user.token
      render status: :forbidden
      return
    end
    @post.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def post_params
      params.require(:post).permit(:token, :content)
    end
end
