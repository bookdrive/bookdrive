class DonorsController < ApplicationController
  filter_access_to :all

  before_filter :confirm_donor, :only => [:downloads, :download_tracks]

  before_filter :cleanse_order_number, :only => [:submit_registration, :create]

  cache_sweeper :donor_sweeper
  
  helper_method :sort_column, :sort_direction
  
  
  # GET /donors
  # GET /donors.xml
  def index
    @donors = Donor.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:per_page => 25, :page => params[:page])
  end

  # GET /donors/1
  # GET /donors/1.xml
  def show
    @donor = Donor.find_by_order_number(params[:id])
  end

  # GET /donors/new
  # GET /donors/new.xml
  def new
    @donor = Donor.new
  end
  
  def downloads
    
  end

  def download_tracks
    
  end


  # GET /donors/register
  # GET /donors/register.xml
  def register
    @donor = Donor.new
    
  end


  # GET /donors/1/edit
  def edit
    @donor = Donor.find_by_order_number(params[:id])
  end


  def submit_registration
    @donor = Donor.new(params[:donor])
    
    # Test for Cookies Disabled
    if !cookies['_bookdrive_session']

      redirect_to cookies_required_path
      
    # Returning donor with existing order number
    elsif cookies['donor_' + @donor.order_number] && existing_donor = Donor.find_by_order_number( @donor.order_number )
    
      redirect_to downloads_donor_path( existing_donor )
    
    # New donor
    elsif @donor.save
      
      cookies['donor_' + @donor.order_number] = {
        :value => @donor.donor_code,
        :expires => 2.months.from_now
      }

      redirect_to( downloads_donor_path(@donor), :notice => 'Thank you for making a donation!')
      
    # Fails (most likely already exists)
    else
      render :action => "register"
    end
    
  end

  # POST /donors
  # POST /donors.xml
  def create

    @donor = Donor.new(params[:donor])
    
    respond_to do |format|
            
      if @donor.save
        format.html { redirect_to(@donor, :notice => 'Donor was successfully created!') }
        format.xml  { render :xml => @donor, :status => :created, :location => @donor }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @donor.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /donors/1
  # PUT /donors/1.xml
  def update
    @donor = Donor.find_by_order_number(params[:id])

#    @donor.saving_address = true
    
    respond_to do |format|
      if @donor.update_attributes(params[:donor])
        format.html { redirect_to(@donor, :notice => 'Donor was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @donor.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /donors/1
  # DELETE /donors/1.xml
  def destroy
    @donor = Donor.find_by_order_number(params[:id])
    
    @donor.destroy

    respond_to do |format|
      format.html { redirect_to(donors_url) }
      format.xml  { head :ok }
    end
  end

  private
  
  def sort_column
    Donor.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
  
  def cleanse_order_number
    # Clean the confirmation code before creating the donor
    params[:donor][:order_number].upcase!
    params[:donor][:order_number].gsub!(/[^0-9A-Z]/,'')
    params[:donor][:order_number].sub!(/(\d{3})-?(\d{7})-?(\d{7})/, '\1-\2-\3')    
  end
      
end
