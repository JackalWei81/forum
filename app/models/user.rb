class User < ActiveRecord::Base

  include Gravtastic
  gravtastic

  has_many :topics, :dependent => :destroy
  has_many :comments, :dependent => :destroy

  has_many :favorite_topics, :dependent => :destroy
  has_many :favorites, :through => :favorite_topics, :source => :topic, :dependent => :destroy

  has_many :likes, :dependent => :destroy
  has_many :like_topics, :through => :likes, :source => :topic, :dependent => :destroy

  has_many :subscribes, :dependent => :destroy
  has_many :subscribe_topics, :through => :subscribes, :source => :topic, :dependent => :destroy

  has_one :profile, :dependent => :destroy

  has_many :friendships, :dependent => :destroy
  has_many :friends, :through => :friendships, :dependent => :destroy
  has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id", :dependent => :destroy
  has_many :inverse_friends, :through => :inverse_friendships, :source => :user, :dependent => :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]

  acts_as_taggable # Alias for acts_as_taggable_on :tags

  def self.from_omniauth(auth)
    # Case 1: Find existing user by facebook uid
    user = User.find_by_fb_uid( auth.uid )
    if user
      user.fb_token = auth.credentials.token
      #user.fb_raw_data = auth
      user.save!
     return user
    end

    # Case 2: Find existing user by email
    existing_user = User.find_by_email( auth.info.email )
    if existing_user
      existing_user.fb_uid = auth.uid
      existing_user.fb_token = auth.credentials.token
      #existing_user.fb_raw_data = auth
      existing_user.save!
      return existing_user
    end

    # Case 3: Create new password
    user = User.new
    user.fb_uid = auth.uid
    user.fb_token = auth.credentials.token
    user.email = auth.info.email
    user.password = Devise.friendly_token[0,20]
    #user.fb_raw_data = auth
    user.save!
    return user
  end


  def short_name
    self.email.split("@").first
  end

  def is_author?(recorder)
    self == recorder.user
    #修改code，簡化程式碼
  end

    def is_admin?
      self.role == "Admin"
  end
end
