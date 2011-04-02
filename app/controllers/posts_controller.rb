class PostsController < ApplicationController
  
  before_filter :find_post, :only => [:edit, :update, :destroy, :show]
  
  def index
    @posts = Post.all
    @post = Post.new
  end
  
  def show
  end
  
  def new
    @post = Post.new
  end
  
  def create
    @post = Post.new(params[:post])
    if @post.save
      redirect_to @post, :notice => 'Post created.'
    else
      render :action => :new
    end
  end
  
  private
  def find_post
    @post = Post.find(params[:id])
  end
end
