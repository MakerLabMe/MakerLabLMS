class Category < ActiveRecord::Base
  attr_accessible :title

  has_many :guides
end
