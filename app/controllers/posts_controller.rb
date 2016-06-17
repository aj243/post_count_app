class PostsController < ApplicationController

  def create
  	user_posts = Post.get_posts(current_user)
    while user_posts.next_page_params do 
      user_posts = Post.get_next_posts(current_user, user_posts.next_page_params)
      save_posts(user_posts)
    end 
    redirect_to root_path
  end

  private

  def post_params
    params.require(:post).permit(:post_id, :created_time, :message)
  end

  def save_posts user_posts
    user_posts.each do |user_post|
      post = current_user.posts.build
      post.message = user_post['story'] or user_post['message']
      post.created_time = user_post['created_time']
      post.post_id = user_post['id']
      post.save
    end
  end

end