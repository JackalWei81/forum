class Topic < ActiveRecord::Base
  validates :name, :description, presence: true

  has_many :comments, :dependent => :destroy
end
