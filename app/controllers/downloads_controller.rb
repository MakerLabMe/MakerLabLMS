class DownloadsController < ApplicationController
  load_and_authorize_resource
  # GET /downloads
  # GET /downloads.json
  def index
    @downloads = Download.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @downloads }
    end
  end

  # GET /downloads/1
  # GET /downloads/1.json
  def show
    @download = Download.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @download }
    end
  end

  # GET /downloads/new
  # GET /downloads/new.json
  def new
    @download = Download.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @download }
    end
  end

  # GET /downloads/1/edit
  def edit
    @download = Download.find(params[:id])
  end

  # POST /downloads
  # POST /downloads.json
  def create
    @download = Download.new(params[:download])

    respond_to do |format|
      if @download.save
        format.html { redirect_to @download, notice: 'Download was successfully created.' }
        format.json { render json: @download, status: :created, location: @download }
      else
        format.html { render action: "new" }
        format.json { render json: @download.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /downloads/1
  # PUT /downloads/1.json
  def update
    @download = Download.find(params[:id])

    respond_to do |format|
      if @download.update_attributes(params[:download])
        format.html { redirect_to @download, notice: 'Download was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @download.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /downloads/1
  # DELETE /downloads/1.json
  def destroy
    @download = Download.find(params[:id])
    @download.destroy

    respond_to do |format|
      format.html { redirect_to downloads_url }
      format.json { head :no_content }
    end
  end
end
