class Guide < ActiveRecord::Base
  attr_accessible :category_id, :img, :overview, :subtitle, :title, :user_id

  belongs_to :user
  belongs_to :category

  has_many :articles
end
