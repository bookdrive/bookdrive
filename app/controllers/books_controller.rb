class BooksController < ApplicationController
  require 'update_wishlist.rb'
  require 'net/http'
  
  filter_access_to :all
  
  before_filter :load_book_from_amazon, :only => :create
  
  helper_method :sort_column, :sort_direction

  
  def update_wishlist
    @wl_books = AmazonWishListFetcher.new.get_updated_wl_books()
    
    @books = Book.all
    @books_map = Hash.new
    @books.each do |b|
      book_identifier = b.title

      if b.author != nil
        book_identifier = b.author + '-' + book_identifier
      end
      
      @books_map[book_identifier] = b
    end
    
    @wl_books.each do |wl_book|
      wl_book_identifier = wl_book.title

      if wl_book.author != nil
        wl_book_identifier = wl_book.author + '-' + wl_book_identifier
      end
      
      if @books_map.include?(wl_book_identifier)
        book = @books_map[wl_book_identifier]
        book.update_from_wl_book(wl_book)
        book.save
      else
        create_book_from_wl(wl_book)
      end
    end
    
    # Expire the home page after the wish list has been updated
    expire_page(:controller => 'pages', :action => 'home')
    
    redirect_to books_path, :notice => 'Updated books from the Amazon Wish List'
  end

  # GET /books
  # GET /books.xml
  def index
    @books = Book.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:per_page => 25, :page => params[:page])
  end

  # GET /books/1
  # GET /books/1.xml
  def show
    @book = Book.find(params[:id])
    @copy = Copy.new(:user => current_user)
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @book }
    end
  end

  # GET /books/new
  # GET /books/new.xml
  def new
    @book = Book.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @book }
    end
  end

  # GET /books/1/edit
  def edit
    @book = Book.find(params[:id])
  end

  # POST /books
  # POST /books.xml
  def create
    
    if @book == nil
      @book = Book.new(params[:book])
    end

    @book.source = current_user
    
    respond_to do |format|
      if @book.save
        format.html { redirect_to(@book, :notice => 'Book was successfully created.') }
        format.xml  { render :xml => @book, :status => :created, :location => @book }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @book.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /books/1
  # PUT /books/1.xml
  def update
    @book = Book.find(params[:id])

    respond_to do |format|
      if @book.update_attributes(params[:book])
        format.html { redirect_to(@book, :notice => 'Book was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @book.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.xml
  def destroy
    @book = Book.find(params[:id])
    @book.destroy

    respond_to do |format|
      format.html { redirect_to(books_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def sort_column
    Book.column_names.include?(params[:sort]) ? params[:sort] : "title"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
  
  def create_book_from_wl(wl_book)    
    new_book = Book.new( wl_book.attribute_hash() )
    new_book.source = 'Wish List'
    new_book.save
  end
  
  def load_book_from_amazon
    logger.debug 'running before filter'
    
    return if (params[:book][:title] && !params[:book][:title].length == 0) || params[:book][:amazon_product_url].blank?

    logger.debug 'Going to load book from amazon'
    @book = Book.new
    
    url = params[:book][:amazon_product_url].sub(/\/ref=.+/,'/ref=wl_it_dp_v/186-9414514-3216048?ie=UTF8&coliid=I186S500LUL8IF&colid=1WJWNVAVRKJVO')
    #html = Net::HTTP.get_response(URI.parse(url)).body.force_encoding("ISO-8859-1").encode('UTF-8')
    html = Net::HTTP.get_response(URI.parse(url)).body
    
    @book.amazon_product_url = url

    matches = html.match(/<h1 class="parseasinTitle"><span id="btAsinTitle" style="">([^<]+)\s*(?:<span style="text-transform:capitalize; font-size: 16px;">([^<]+)<\/span>)?<\/span><\/h1>/)
    if matches && matches.length > 0
      @book.title = matches[1]
      @book.amazon_cover_type = matches[2]
      @book.amazon_cover_type.gsub!(/[\[\(\]\)]/,'')
    end
        
    matches = html.match(/<td><span\s+class="listprice">\$([\d\.]+)<\/span><\/td>/)
    if matches && matches.length > 0
      @book.amazon_strike_price = matches[1]
    end

    matches = html.match(/>([^<]+)<\/a>.+?\(Author\)/)
    if matches && matches.length > 0
      @book.author = matches[1]
    end

    matches = html.match(/<td><b\s+class="priceLarge">\$([\d\.]+)<\/b>/)
    if matches && matches.length > 0
      @book.amazon_price = matches[1]
    end

    matches = html.match(/<div class="buying" style="padding-bottom: 0.75em;">\s*<span class="avail[^"]*?">([^<]+)<\/span>/)
    if matches && matches.length > 0
      @book.amazon_availability = matches[1]
      @book.amazon_availability.sub!(/.$/,'')    
    end
    
    matches = html.match(/Ships from and sold by <b>([^<]+)<\/b>/)
    if matches && matches.length > 0
      @book.amazon_merchant = matches[1]
    end
    
    matches = html.match(/src="([^"]+)" id="prodImage"/)
    if matches && matches.length > 0
      @book.amazon_image_url = matches[1]
      @book.amazon_image_original_url = @book.amazon_image_url.sub(/(.+I\/[^\.]+)\..+/,'\1.jpg')
      @book.amazon_image_url.sub!(/_PIsitb-.+?,-[\d]+/,'')
    end

  end
end
