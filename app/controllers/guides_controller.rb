class GuidesController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :index]
  before_filter :find_guide_and_auth, :only => [:edit_title,:update_title, :move, :destroy]
  before_filter :only => [:toggle_comments_closed, :toggle_sticky] do |c|
    auth_admin
  end

  # GET /guides
  # GET /guides.json
  def index
    respond_to do |format|
      format.html {
        per_page = Siteconf::HOMEPAGE_TOPICS
        @title = '最新学习教程'
        if params[:page].present?
          current_page = params[:page].to_i
          @title += " (第 #{current_page} 页)"
        else
          current_page = 1
        end

        @guides = Guide.cached_pagination(current_page, per_page, 'updated_at')

        @canonical_path = guides_path
        @canonical_path += "?page=#{current_page}" if current_page > 1

        @seo_description = @title
      }
      #format.atom {
      #  @feed_items = Guide.recent_topics(Siteconf::HOMEPAGE_TOPICS)
      #  @last_update = @feed_items.first.updated_at unless @feed_items.empty?
      #  render :layout => false
      #}
    end
  end

  # GET /guides/1
  # GET /guides/1.json
  def show
    raise ActiveRecord::RecordNotFound.new if params[:id].to_i.to_s != params[:id]

    @guide = Guide.find_cached(params[:id])
    store_location
    # NOTE
    # We can't use @topic.increment!(:hit) here,
    # because updated_at is part of the cache key
    # ActiveRecord::Base.connection.execute("UPDATE topics SET hit = hit + 1 WHERE topics.id = #{@topic.id}")

    @title = @guide.title
    @category = @guide.cached_assoc_object(:category)

    @total_bookmarks = @guide.bookmarks.count

    @seo_description = "#{@category.title} - #{@guide.user.nickname} - #{@guide.title}"

    respond_to do |format|
      format.html
      format.mobile
    end
  end

  # GET /guides/new
  # GET /guides/new.json
  def new
    @guide = Guide.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @guide }
    end
  end

  # GET /guides/1/edit
  def edit
    @guide = Guide.find(params[:id])
  end

  def new_from_home
    @guide = Guide.new
  end
  # POST /guides
  # POST /guides.json
  def create
    category_id = params[:guide].delete(:category_id)
    @guide = Guide.new(params[:guide])
    @guide.category = Category.find(category_id) if category_id.present?
    @guide.user = current_user
    if @guide.save
      redirect_to @guide
    else
      render :new
    end
  end

  def create_from_home
    category_id = params[:guide].delete(:category_id)
    @guide = Guide.new(params[:guide])
    @guide.category = Category.find(category_id) if category_id.present?
    @guide.user = current_user

    if @guide.save
      redirect_to guide_path(@guide)
    else
      render :new_from_home
    end
  end

  # PUT /guides/1
  # PUT /guides/1.json
  def update
    @guide = Guide.find(params[:id])
    if params[:new_category_id].present?
      # move to new node
      @new_category = Category.find(params[:new_category_id])
      respond_to do |format|
        format.js {
          if @new_category.present?
            @guide.category = @new_category
            if @guide.save
              render :js => "window.location.reload()"
            else
              render :js => "$.facebox('移动教程失败')"
            end
          else
            render :js => "$.facebox('分类不存在')"
          end
        }
      end
    else
      if @guide.update_attributes(params[:guide])
        redirect_to @guide
      else
        flash[:error] = '之前的更新有误，请编辑后再提交'
        render :edit
      end
    end
  end

  def edit_title
    respond_to do |f|
      f.js
    end
  end

  def update_title
    respond_to do |f|
      f.js {
        unless @guide.update_attributes(params[:guide])
          render :text => :error, :status => :unprocessable_entity
        end
      }
    end
  end

  def move
    respond_to do |format|
      format.js
    end
  end

  # DELETE /guides/1
  # DELETE /guides/1.json
  def destroy
    @guide = Guide.find(params[:id])
    @guide.destroy

    respond_to do |format|
      format.html { redirect_to guides_url }
      format.json { head :no_content }
    end
  end

  private
    def find_category
      @category = Category.find(params[:category_id])
    end

    def find_guide_and_auth
      @guide = Guide.find(params[:id])
      authorize! :update, @guide, :message => '你没有权限管理此教程'
    end
end
