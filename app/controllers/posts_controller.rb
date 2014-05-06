class PostsController < ApplicationController
  skip_before_filter :require_login, only: [:index, :show]

  def index
  	@posts = Post.all
  end
  
  def show
  	@post = Post.find(params[:id])
    @comments = @post.comments.joins(:user)
  end

  def new
  	@post = Post.new
  end

  def create
    @change_params = post_params
    @change_params[:user_id] = current_user.id
    source = create_source(@change_params[:content], @change_params[:user_id])
    source_name = ("user_" + @change_params[:user_id].to_s + "_" +Time.now.to_s + "." + source.format).delete(" ")
    @change_params[:content] = source_name
  	@post = Post.new @change_params
    if @post.save
      source.write(Rails.root.join("public/users/" + @change_params[:user_id].to_s + "/" + source_name))
      redirect_to root_url
    else
      render action: 'new'
    end
  end

  def destroy
  end

  def comment_create
    @comment_params = comment_params
    @comment_params[:user_id] = current_user.id
    @comment = Comment.new @comment_params
    if @comment.save
      redirect_to post_path(:id => @comment_params[:post_id])
    else
      render action: 'new'
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:post_id, :content)
  end

  def post_params
    params.require(:post).permit(:title, :description, :content)
  end
  
  def create_source(picture, user_id)
    user_path = Rails.root.join("public/users/" + user_id.to_s + "/")
    File.open(user_path + picture.original_filename, 'wb') do |file|
       file.write(picture.read)
    end
    source = Magick::Image.read(user_path + picture.original_filename).first
    File.delete(user_path + picture.original_filename)
    source.resize_to_fit!(500)
  end

end
