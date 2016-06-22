class FacebookWorker
	include Sidekiq::Worker
	sidekiq_options retry: false

  def perform id
  	@current_user = User.find_by(id)
    user_posts = Post.get_posts(@current_user.id)
    @post_count = 1
    if !user_posts.blank?
      save_posts(user_posts)
      update_last_post_time(user_posts)
      while user_posts.next_page_params do 
        user_posts = Post.get_next_posts(@current_user.id, user_posts.next_page_params)
        save_posts(user_posts)
      end
    end
  end

  private

  def save_posts user_posts
    redis = Redis.new
    user_posts.each do |user_post|
      post = @current_user.posts.build
      # post.update_attribute(:message, "#{user_post['story']}" or "#{user_post['message']}"), created_time:)
      post.message = (user_post['story'] or user_post['message'])
      post.created_time = user_post['created_time']
      post.post_id = user_post['id']
      post.save
      redis.publish("channel_#{@current_user.id}", @post_count)
      @post_count += 1
    end
  end

  def update_last_post_time user_posts
    @current_user.last_post_time = user_posts[0]['created_time']
    @current_user.save
  end

end

