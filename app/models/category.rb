class Category < ActiveRecord::Base

  has_many :topic_categoryships, :dependent => :destroy
  has_many :topics, :through => :topic_categoryships, :dependent => :destroy

end
