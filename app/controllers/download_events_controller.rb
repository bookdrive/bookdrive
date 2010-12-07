class DownloadEventsController < ApplicationController

#  before_filter :authenticate_user!

#  filter_resource_access
  
  # GET /download_events
  # GET /download_events.xml
  def index
    @download_events = DownloadEvent.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @download_events }
    end
  end

  # GET /download_events/1
  # GET /download_events/1.xml
  def show
    @download_event = DownloadEvent.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @download_event }
    end
  end

  # GET /download_events/new
  # GET /download_events/new.xml
  def new
    @download_event = DownloadEvent.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @download_event }
    end
  end

  # GET /download_events/1/edit
  def edit
    @download_event = DownloadEvent.find(params[:id])
  end

  # POST /download_events
  # POST /download_events.xml
  def create
    @download_event = DownloadEvent.new(params[:download_event])

    respond_to do |format|
      if @download_event.save
        format.html { redirect_to(@download_event, :notice => 'Download event was successfully created.') }
        format.xml  { render :xml => @download_event, :status => :created, :location => @download_event }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @download_event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /download_events/1
  # PUT /download_events/1.xml
  def update
    @download_event = DownloadEvent.find(params[:id])

    respond_to do |format|
      if @download_event.update_attributes(params[:download_event])
        format.html { redirect_to(@download_event, :notice => 'Download event was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @download_event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /download_events/1
  # DELETE /download_events/1.xml
  def destroy
    @download_event = DownloadEvent.find(params[:id])
    @download_event.destroy

    respond_to do |format|
      format.html { redirect_to(download_events_url) }
      format.xml  { head :ok }
    end
  end
end
