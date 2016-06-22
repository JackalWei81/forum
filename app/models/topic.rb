class Topic < ActiveRecord::Base
  validates :name, :description, presence: true
end
