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

  acts_as_taggable # Alias for acts_as_taggable_on :tags

  def find_my_favorite(user)
    self.favorite_topics.where( :user => user ).first
  end

  def find_my_like(user)
    self.likes.where( :user => user ).first
  end

  def find_my_subscribe(user)
    self.subscribes.where( :user => user ).first
  end

  def read_by(user)
    if self.access == 1
      self.user_id == user.id if user
    elsif self.access == 4
      (Friendship.where(:user_id => self.user_id, :friend_id => user.id).first && Friendship.where(:user_id => user.id, :friend_id => self.user_id).first) || (self.user_id == user.id) if user
    else
      return true
    end
  end

  def written_by(user)
    if self.access == 1
      self.user_id == user.id if user
    elsif self.access == 2
      self.user_id == user.id
    elsif self.access == 4
      (Friendship.where(:user_id => self.user_id, :friend_id => user.id).first && Friendship.where(:user_id => user.id, :friend_id => self.user_id).first) || (self.user_id == user.id) if user
    else
      return true
    end
  end

end
