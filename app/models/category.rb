# encoding: utf-8
class Category < ActiveRecord::Base
  include Rabel::ActiveCache
  attr_accessible :title, :presence => true

  has_many :guides, :dependent => :destroy

  def can_delete?
    self.guides.count == 0
  end

end
