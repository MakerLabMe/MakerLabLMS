# encoding: utf-8
class Article < ActiveRecord::Base
  include Rabel::ActiveCache
  attr_accessible :complete, :content, :guide_id, :title
  belongs_to :guide
  has_many :comments, :as => :commentable, :dependent => :destroy
end
