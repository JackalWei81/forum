class Topic < ActiveRecord::Base
  validates :name, :description, presence: true

  has_many :comments, :dependent => :destroy

  has_many :topic_categoryships, :dependent => :destroy
  has_many :categories, :through => :topic_categoryships, :dependent => :destroy

  belongs_to :user
end
