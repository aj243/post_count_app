class ScheduledWorker
	include Sidekiq::Worker
	# sidekiq_options retry: false

  def perform
    users = User.all
  	users.each do |user|
      FacebookUpdateWorker.perform_async(user.id)
    end
  end

end

Sidekiq::Cron::Job.create(name: 'Scheduled Worker - update data', cron: '*/1 * * * *', class: 'ScheduledWorker')