class PressController < ApplicationController
  before_filter :authenticate_user!, :except => [:index]
  caches_page :index
  cache_sweeper :press_sweeper
  
  filter_resource_access
  
  # GET /press
  # GET /press.xml
  def index
    @press = Press.order("date DESC")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @press }
    end
  end

  # GET /press/1
  # GET /press/1.xml
  def show
    @press = Press.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @press }
    end
  end

  # GET /press/new
  # GET /press/new.xml
  def new
    @press = Press.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @press }
    end
  end

  # GET /press/1/edit
  def edit
    @press = Press.find(params[:id])
  end

  # POST /press
  # POST /press.xml
  def create
    @press = Press.new(params[:press])

    respond_to do |format|
      if @press.save
        format.html { redirect_to(@press, :notice => 'Press was successfully created.') }
        format.xml  { render :xml => @press, :status => :created, :location => @press }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @press.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /press/1
  # PUT /press/1.xml
  def update
    @press = Press.find(params[:id])

    respond_to do |format|
      if @press.update_attributes(params[:press])
        format.html { redirect_to(@press, :notice => 'Press was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @press.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /press/1
  # DELETE /press/1.xml
  def destroy
    @press = Press.find(params[:id])
    @press.destroy

    respond_to do |format|
      format.html { redirect_to(press_url) }
      format.xml  { head :ok }
    end
  end
end
