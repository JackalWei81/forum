class User < ActiveRecord::Base

  include Gravtastic
  gravtastic

  has_many :topics, :dependent => :destroy
  has_many :comments, :dependent => :destroy

  has_many :favorite_topics, :dependent => :destroy
  has_many :favorites, :through => :favorite_topics, :source => :topic, :dependent => :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  def short_name
    self.email.split("@").first
  end

  def is_author?(recorder)
    if self.id == recorder.user_id
      return true
    end
  end
end
