# encoding: utf-8
class Article < ActiveRecord::Base
  include Notifiable
  include Rabel::ActiveCache

  DEFAULT_HIT = 0
  default_value_for :hit, DEFAULT_HIT
  default_value_for :content, ''
  default_value_for :involved_at do
    Time.zone.now
  end

  attr_accessible :title, :content, :complete, :guide_id
  attr_accessible :title, :content, :complete, :guide_id, :comments_closed, :as => :admin
  belongs_to :guide
  belongs_to :user
  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :notifications, :as => :notifiable, :dependent => :destroy

  validates :guide_id, :user_id, :title, :presence => true

  after_create :send_notifications
  after_save :update_guide

  def last_comment
    self.comments.order('created_at ASC').last
  end

  def allow_modification_by?(user)
    user.can_manage_site?
  end

  def notifiable_title
    self.guide.title + " - " + title
  end

  def notifiable_path
    "/guides/#{self.guide.id}/articles/#{id}"
  end

  def self.latest_involved_topics(num)
    order('involved_at DESC').limit(num).all
  end

  def self.recent_topics(num)
    ts = select('updated_at').order('updated_at DESC').first.try(:updated_at)
    return Rabel::Model::EMPTY_DATASET unless ts.present?
    Rails.cache.fetch("topics/recent/#{self.count}/#{num}-#{ts}") do
      order('involved_at DESC').limit(num).all
    end
  end

  def mention_check_text
    self.title + self.content
  end

  def mentioned_users
    mentioned_names = self.mention_check_text.scan(Notifiable::MENTION_REGEXP).collect {|matched| matched.first}.uniq
    mentioned_names.delete(self.user.nickname)
    mentioned_names.map { |name| User.find_by_nickname(name) }.compact
  end

  def prev_article(guide)
    guide.articles.where(['id < ?', self.id]).order('created_at DESC').first
  end

  def next_article(guide)
    guide.articles.where(['id > ?', self.id]).order('created_at ASC').first
  end

  private

    def send_notifications
      mentioned_users.each do |user|
        Notification.notify(
          user,
          self,
          self.user,
          Notification::ACTION_TOPIC,
          self.content
        )
      end
    end

    def update_guide
      self.guide.touch
    end
end
