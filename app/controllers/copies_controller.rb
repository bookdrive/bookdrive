class CopiesController < ApplicationController
  filter_access_to :all
  
  # GET /copies
  # GET /copies.xml
  def index
    @book = Book.find(params[:book_id])
    @copies = Copy.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @copies }
    end
  end

  # GET /copies/1
  # GET /copies/1.xml
  def show
    @copy = Copy.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @copy }
    end
  end

  # GET /copies/new
  # GET /copies/new.xml
  def new
    @copy = Copy.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @copy }
    end
  end

  # GET /copies/1/edit
  def edit
    @copy = Copy.find(params[:id])
  end

  # POST /copies
  # POST /copies.xml
  def create
    @book = Book.find(params[:book_id])
    
    for i in 1..params[:copy][:copy_count].to_i do
      @copy = Copy.new(params[:copy])
      @copy.book = @book
      @copy.user = current_user
      @copy.save
    end
    
    redirect_to( @book, :notice => 'Copies successfully added.' )
  end

  # PUT /copies/1
  # PUT /copies/1.xml
  def update
    @copy = Copy.find(params[:id])

    respond_to do |format|
      if @copy.update_attributes(params[:copy])
        format.html { redirect_to(@copy, :notice => 'Copy was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @copy.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /copies/1
  # DELETE /copies/1.xml
  def destroy
    @book = Book.find(params[:book_id])
    
    @copy = Copy.find(params[:id])
    @copy.destroy

    respond_to do |format|
      format.html { redirect_to(@book) }
      format.xml  { head :ok }
    end
  end
end
