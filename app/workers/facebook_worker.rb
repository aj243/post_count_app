class FacebookWorker
	include Sidekiq::Worker
	sidekiq_options retry: false

  def perform id
  	current_user = User.find_by(id)
    user_posts = Post.get_posts(current_user)
    if !user_posts.blank?
      save_posts(user_posts, current_user)
      update_last_post_time(user_posts, current_user)
      while user_posts.next_page_params do 
        user_posts = Post.get_next_posts(current_user, user_posts.next_page_params)
        save_posts(user_posts, current_user)
      end 
    end
  end

  private

  def save_posts user_posts, current_user
    user_posts.each do |user_post|
      post = current_user.posts.build
      post.message = (user_post['story'] or user_post['message'])
      post.created_time = user_post['created_time']
      post.post_id = user_post['id']
      post.save
    end
  end

  def update_last_post_time user_posts, current_user
    current_user.last_post_time = user_posts[0]['created_time']
    current_user.save
  end

end

