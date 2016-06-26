class Topic < ActiveRecord::Base
  validates :name, :description, presence: true

  has_many :comments, :dependent => :destroy

  has_many :topic_categoryships, :dependent => :destroy
  has_many :categories, :through => :topic_categoryships, :dependent => :destroy

  belongs_to :user

  has_many :favorite_topics, :dependent => :destroy
  has_many :favorite_by, :through => :favorite_topics, :source => :user, :dependent => :destroy



  def find_my_favorite(user)
  self.favorite_topics.where( :user => user ).first
  end
end
