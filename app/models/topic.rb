class Topic < ActiveRecord::Base
  validates :name, :description, presence: true

  has_many :comments, :dependent => :destroy

  has_many :topic_categoryships, :dependent => :destroy
  has_many :categories, :through => :topic_categoryships, :dependent => :destroy

  belongs_to :user

  has_many :favorite_topics, :dependent => :destroy
  has_many :favorite_by, :through => :favorite_topics, :source => :user, :dependent => :destroy

  has_many :likes, :dependent => :destroy
  has_many :likes_by, :through => :likes, :source => :user, :dependent => :destroy

  has_many :subscribes, :dependent => :destroy
  has_many :subscribes_by, :through => :subscribes, :source => :user, :dependent => :destroy

  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  has_many :photos, :dependent => :destroy


  def find_my_favorite(user)
    self.favorite_topics.where( :user => user ).first
  end

  def find_my_like(user)
    self.likes.where( :user => user ).first
  end

  def find_my_subscribe(user)
    self.subscribes.where( :user => user ).first
  end
end
