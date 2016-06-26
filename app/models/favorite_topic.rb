class FavoriteTopic < ActiveRecord::Base

  belongs_to :topic
  belongs_to :user

end
