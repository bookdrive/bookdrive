class DonorsController < ApplicationController
  before_filter :authenticate_user!, :except => [:create, :show]
  before_filter :confirm_donor, :except => [:create, :new]
  
  # GET /donors
  # GET /donors.xml
  def index
    @donors = Donor.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @donors }
    end
  end

  # GET /donors/1
  # GET /donors/1.xml
  def show

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @donor }
    end
  end

  # GET /donors/new
  # GET /donors/new.xml
  def new
    @donor = Donor.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @donor }
    end
  end

  # GET /donors/1/edit
  def edit
  end

  # POST /donors
  # POST /donors.xml
  def create
    @donor = Donor.new(params[:donor])
    
    
    respond_to do |format|

      if existing_donor = Donor.find_by_confirmation_code( @donor[:confirmation_code] )
        format.html { redirect_to donor_path( existing_donor ) }
      end

      if @donor.save

        cookies.permanent['donor_' + @donor.confirmation_code] = {
          :value => @donor.donor_code,
          :expires => 1.month.from_now
        }

        format.html { redirect_to(@donor, :notice => 'Thank you for making a donation!') }
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
    @donor.destroy

    respond_to do |format|
      format.html { redirect_to(donors_url) }
      format.xml  { head :ok }
    end
  end
      
end
