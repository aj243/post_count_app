class ScheduledWorker
	include Sidekiq::Worker
	# sidekiq_options retry: false

  def perform
    users = User.all
    if users.present?
    	users.each do |user|
        FacebookWorker.perform_async(user.id)
      end
    end
  end

end

Sidekiq::Cron::Job.create(name: 'Scheduled Worker - update data', cron: '*/1 * * * *', class: 'ScheduledWorker')