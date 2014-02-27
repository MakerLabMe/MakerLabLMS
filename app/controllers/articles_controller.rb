class ArticlesController < ApplicationController
  load_and_authorize_resource
  # GET /articles
  # GET /articles.json
  before_filter :get_guide

  def index
    @articles = @guide.articles.all
    @category = Category.find(@guide.category_id)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @articles }
    end
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
    @article = Article.find(params[:id])
    @articles = @guide.articles
    @next_article = @articles.where("id > #{params[:id]}").first
    @pre_article = @articles.where("id < #{params[:id]}").last
    @category = Category.find(@guide.category_id)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @article }
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
    @article = Article.new(params[:article])
    @article.guide_id = params[:guide_id]

    respond_to do |format|
      if @article.save
        format.html { redirect_to @guide, notice: 'Article was successfully created.' }
        format.json { render json: @guide, status: :created, location: @article }
      else
        format.html { render action: "new" }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /articles/1
  # PUT /articles/1.json
  def update
    @article = Article.find(params[:id])
    @article.guide_id = params[:guide_id]

    respond_to do |format|
      if @article.update_attributes(params[:article])
        format.html { redirect_to [@guide,@article], notice: 'Article was successfully updated.' }
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
      format.html { redirect_to @guide }
      format.json { head :no_content }
    end
  end


  private

  def get_guide
    @guide = Guide.find(params[:guide_id])
  end
end
