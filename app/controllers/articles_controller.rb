class ArticlesController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :index]
  before_filter :get_guide, :except => [:show]
  # GET /articles
  # GET /articles.json
  def index
    respond_to do |format|
      format.html {
        @title = @guide.title
        @articles = @guide.articles.cached_all()
        @seo_description = @title
      }
#      format.atom {
#        @feed_items = Topic.recent_topics(Siteconf::HOMEPAGE_TOPICS)
#        @last_update = @feed_items.first.updated_at unless @feed_items.empty?
#        render :layout => false
#      }
    end
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
    raise ActiveRecord::RecordNotFound.new if params[:id].to_i.to_s != params[:id]

    @article = Article.find_cached(params[:id])
    store_location
    # NOTE
    # We can't use @topic.increment!(:hit) here,
    # because updated_at is part of the cache key
    ActiveRecord::Base.connection.execute("UPDATE articles SET hit = hit + 1 WHERE articles.id = #{@article.id}")

    @title = @article.title
    @guide = @article.cached_assoc_object(:guide)

    @total_comments = @article.comments_count
    @total_pages = (@total_comments * 1.0 / Siteconf.pagination_comments.to_i).ceil
    @current_page = params[:p].nil? ? @total_pages : params[:p].to_i
    @per_page = Siteconf.pagination_comments.to_i
    @comments = @article.cached_assoc_pagination(:comments, @current_page, @per_page, 'created_at', Rabel::Model::ORDER_ASC)

    @new_comment = @article.comments.new

    @canonical_path = "/guides/#{@guide.id}/articles/#{params[:id]}"
    @canonical_path += "?p=#{@current_page}" if @total_pages > 1
    @seo_description = "#{@guide.title} - #{@guide.user.nickname} - #{@article.title}"

    @prev_topic = @article.prev_topic(@guide)
    @next_topic = @article.next_topic(@guide)

    respond_to do |format|
      format.html
      format.mobile
    end
  end

  # GET /articles/new
  # GET /articles/new.json
  def new
    @article = Article.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @article }
    end
  end

  # GET /articles/1/edit
  def edit
    @article = Article.find(params[:id])
  end

  # POST /articles
  # POST /articles.json
  def create
    @article = @guide.articles.new(params[:article])
    @article.user = current_user

    respond_to do |format|
      if @article.save
        redirect_to @guide
      else
        render :new
      end
    end
  end

  # PUT /articles/1
  # PUT /articles/1.json
  def update
    @article = Article.find(params[:id])

    respond_to do |format|
      if @article.update_attributes(params[:article])
        format.html { redirect_to @article, notice: 'Article was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    respond_to do |format|
      format.html { redirect_to articles_url }
      format.json { head :no_content }
    end
  end

  private

  def get_guide
    @guide = Guide.find(params[:guide_id])
  end
end
