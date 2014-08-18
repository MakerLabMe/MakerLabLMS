# encoding: utf-8
class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show, :topics, :my_topics]
  layout "base", :only => [:index]

  def index
    @hot_users = User.order("comments_count DESC, topics_count DESC").limit(50)
    @new_users = User.order("created_at DESC ").limit(50)
    @title = "MakerLab创客实验室活跃及最新用户"
    @canonical_path = "/users"
    @seo_description = "#{@title} - #{Siteconf.site_name}"
  end
  def show
    @user = User.find_by_attr_cached!(:nickname, params[:nickname])
    store_location

    @title = @user.nickname
    @canonical_path = "/member/#{@title}"

    @signature = @user.account.signature
    @weibo_link = cannonical_url(@user.account.weibo_link)
    @personal_website = cannonical_url(@user.account.personal_website)
    @location = @user.account.location
    @introduction = @user.account.introduction

    @nickname_tip = (@user == current_user) ? '我' : @user.nickname
    @seo_description = "#{@user.nickname} - #{@signature}"

    respond_to do |format|
      format.html
      format.mobile { add_breadcrumb @user.nickname }
    end
  end

  def guides
    @user = User.find_by_attr_cached!(:nickname, params[:nickname])

    @current_page = params[:page].present? ? params[:page] : 1
    @guides = @user.cached_assoc_pagination(:guides, @current_page, 20, 'created_at')

    @title = "#{@user.nickname} 创建的所有学习教程"
    @seo_description = "#{@title} - #{Siteconf.site_name}"
  end
  def topics
    @user = User.find_by_attr_cached!(:nickname, params[:nickname])

    @current_page = params[:page].present? ? params[:page] : 1
    @topics = @user.cached_assoc_pagination(:topics, @current_page, 20, 'created_at')

    @title = "#{@user.nickname} 创建的所有主题"
    @seo_description = "#{@title} - #{Siteconf.site_name}"
  end

  def edit
    @user = current_user
    @user.build_account unless @user.account.present?
    @title = '设置'

    respond_to do |format|
      format.html
      format.mobile
    end
  end

  def update_account
    @user = current_user
    if @user.update_without_password(params[:user])
      flash[:success] = '个人设置成功更新'
      sign_in :user, current_user, :bypass => true
      redirect_to settings_path
    else
      flash[:error] = '个人设置保存失败'
      render :edit
    end
  end

  def update_password
    @user = current_user
    if @user.update_with_password(params[:user])
      flash[:success] = '密码已成功更新，下次请用新密码登录'
      sign_in :user, current_user, :bypass => true
      redirect_to settings_path
    else
      flash[:error] = '密码更新失败'
      render :edit
    end
  end

  def update_avatar
    @user = current_user
    if params[:user].present?
      if @user.update_without_password(params[:user])
        flash[:success] = '头像更新成功'
        redirect_to settings_path + '#avatar'
      else
        flash[:error] = '头像更新失败'
        render :edit
      end
    else
      redirect_to settings_path + '#avatar', :notice => '请选择要上传的头像'
    end
  end

  def my_topics
    if params[:nickname].present?
      @user = User.find_by_attr_cached!(:nickname, params[:nickname])
      @my_topics = @user.bookmarked_topics
      @my_guides = @user.bookmarked_guides
      @title = @user.nickname + ' 的收藏'
    else
      @my_topics = current_user.bookmarked_topics
      @my_guides = current_user.bookmarked_guides
      @title = '我的收藏'
    end

    respond_to do |format|
      format.html
      format.mobile { add_breadcrumb(@title) }
    end
  end

  def my_following
    @my_followed_users = current_user.followed_users
    @followed_topic_timeline = current_user.followed_topic_timeline
    @title = '我的特别关注'

    respond_to do |format|
      format.html
      format.mobile { add_breadcrumb(@title) }
    end
  end

  def follow
    @followed_user = User.find_by_nickname!(params[:nickname])
    unless current_user.following?(@followed_user)
      flash[:error] = '加入特别关注失败' unless current_user.follow(@followed_user)
    end
    redirect_to member_path(params[:nickname])
  end

  def unfollow
    @followed_user = User.find_by_nickname!(params[:nickname])
    if current_user.following?(@followed_user)
      flash[:error] = '取消特别关注失败' unless current_user.unfollow(@followed_user)
    end
    redirect_to member_path(params[:nickname])
  end
end
