class FacebookWorker
	include Sidekiq::Worker
	sidekiq_options retry: false

  def perform id
  	@current_user = User.find_by(id)
    if @current_user.present?
      if @current_user.last_post_time.nil?
        user_posts = Post.get_posts(@current_user.id)
        update_last_post_time(user_posts)
        @post_count = 1
      else 
        user_posts = Post.update_next_posts(@current_user.id, @current_user.last_post_time)
        update_last_post_time(user_posts)
        @post_count = 1
      end
      if user_posts.present?
        save_posts(user_posts)
        while user_posts.next_page_params do 
          user_posts = Post.get_next_posts(@current_user.id, user_posts.next_page_params)
          save_posts(user_posts)
        end
      end
    end
  end

  private

  def save_posts user_posts
    user_posts.each do |user_post|
      post = @current_user.posts.build
      post.update_attributes(message: (user_post['story'] or user_post['message']), post_id: user_post['id'],
                            created_time: user_post['created_time'])
      $redis.publish("channel_#{@current_user.id}", @post_count)
      @post_count += 1
    end
  end

  def update_last_post_time user_posts
    @current_user.last_post_time = user_posts[0]['created_time']
    @current_user.save
  end

end