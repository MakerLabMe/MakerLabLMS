class HomeController < ApplicationController
  def index
    @guides = Guide.all
  end
end
