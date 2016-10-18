class PostsController < ApplicationController
   
	  def destroy
	    @post = Post.find(params[:id])
	    @post.destroy
	    redirect_to posts_path
	  end  

	  def index
	     @posts = Post.all.order(created_at: :desc).page(params[:page])
	  end
    
      def new
	     @post = Post.new
	  end
    
	  def create
	     @post = Post.new(post_params)

          if @post.save
            redirect_to @post
          else
            render :new, status: :unprocessable_entity
          end
	  end

	  def show
	     @post = Post.find(params[:id])
       @comment = Post.find(params[:id]).comments.build
    end
      
      
    def edit
        @post = Post.find(params[:id])
    end
    
    def update
        @post = Post.find(params[:id])
        
        if @post.update(post_params)
            redirect_to @post
            else
            render :edit, status: :unprocessable_entity
        end
    end

    private

	  def post_params
	      params.require(:post).permit(:title, :text, :image, :image_cache, :remove_image, :comment)
	  end
end