namespace :dev do

  task :schedule => :environment do
    topics = Topic.where(:status => "scheduled")
    topics.each do |topic|
      if topic.schedule - Time.now.to_date == 0
        ScheduleTopicJob.perform_later(topic)
      end
    end
  end

 end