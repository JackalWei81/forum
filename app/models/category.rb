class Category < ActiveRecord::Base
  validates :name, presence: true

  has_many :topic_categoryships, :dependent => :destroy
  has_many :topics, :through => :topic_categoryships, :dependent => :destroy

end
