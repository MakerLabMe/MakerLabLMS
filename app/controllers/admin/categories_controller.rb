# encoding: utf-8
class Admin::CategoriesController < Admin::BaseController

  def index
    @categories = Category.all
    @title = '教程分类'
  end

  def new
    @category = Category.new
    respond_to do |format|
      format.js {
        @title = '添加教程分类'
        render :show_form
      }
    end
  end

  def create
    @category = Category.new(params[:category])
    respond_to do |format|
      if @category.save
        format.js
      else
        format.js { render :show_form }
      end
    end
  end

  def edit
    @category = Category.find(params[:id])
    respond_to do |format|
      format.js {
        @title = '修改分类'
        render :show_form
      }
    end
  end

  def update
    @category = Category.find(params[:id])
    respond_to do |format|
      if @category.update_attributes(params[:category])
        format.js { render :js => 'window.location.reload()' }
      else
        format.js { render :show_form }
      end
    end
  end

  def destroy
    @category = Category.find(params[:id])
    respond_to do |format|
      if @category.can_delete? and @category.destroy
        format.js
      else
        format.js { render :text => :error, :status => :unprocessable_entity }
      end
    end
  end
end
