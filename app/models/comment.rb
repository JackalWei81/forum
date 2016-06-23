class Comment < ActiveRecord::Base
  validates :name, presence: true

  belongs_to :topic, :counter_cache => true
end
