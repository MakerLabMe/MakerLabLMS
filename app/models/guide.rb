# encoding: utf-8
class Guide < ActiveRecord::Base
  include Notifiable
  include Rabel::ActiveCache
  attr_accessible :category_id, :feature_id, :img, :overview, :publish, :subtitle, :title, :user_id

  belongs_to :user
  belongs_to :category

  has_many :articles, :dependent => :destroy
  has_many :notifications, :as => :notifiable, :dependent => :destroy
  has_many :bookmarks, :as => :bookmarkable, :dependent => :destroy

  after_create :send_notifications

  def notifiable_title
    title
  end

  def notifiable_path
    "/guides/#{id}"
  end

  def mention_check_text
    self.title + self.overview
  end

  def mentioned_users
    mentioned_names = self.mention_check_text.scan(Notifiable::MENTION_REGEXP).collect {|matched| matched.first}.uniq
    mentioned_names.delete(self.user.nickname)
    mentioned_names.map { |name| User.find_by_nickname(name) }.compact
  end

  def allow_modification_by?(user)
    (self.user == user) || user.can_manage_site?
  end

  private

    def send_notifications
      mentioned_users.each do |user|
        Notification.notify(
          user,
          self,
          self.user,
          Notification::ACTION_TOPIC,
          self.overview
        )
      end
    end
end
