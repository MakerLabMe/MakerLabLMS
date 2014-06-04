# encoding: utf-8
class Admin::GuidesController < Admin::BaseController
  def index
    @guides = Guide.order('created_at DESC').page(params[:page])
    @title = '学习教程'
  end

  def destroy
    @guide = Guide.find(params[:id])
    if @guide.destroy
      redirect_to admin_guides_path
    else
      redirect_to admin_root_path
    end
  end
end
