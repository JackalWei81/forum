class ScheduleTopicJob < ActiveJob::Base
  queue_as :default

  def perform(topic)
    topic.update!(:status => "published", :schedule => "")
  end
end
