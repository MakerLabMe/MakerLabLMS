class Article < ActiveRecord::Base
  attr_accessible :content, :guide_id, :title

  belongs_to :guide
end
