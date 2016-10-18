class PagesController < ApplicationController
 def index
 	@posts = Post.all.order(created_at: :desc).page(params[:page])

 end

 def post_params
	params.require(:post).permit(:title, :text, :image, :image_cache, :remove_image, :comment)
 end



end
