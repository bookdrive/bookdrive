class BooksController < ApplicationController
  require 'update_wishlist.rb'
  
  filter_resource_access

  helper_method :sort_column, :sort_direction
    
  
  def update_wishlist
    @wl_books = AmazonWishListFetcher.new.get_updated_wl_books()
    
    @books = Book.all
    @books_map = Hash.new
    @books.each do |b|
      @books_map[b.author + '-' + b.title] = b
    end
    
    @wl_books.each do |wl_book|

      book_identifier = wl_book.title

      if wl_book.author != nil
        book_identifier = wl_book.author + '-' + book_identifier
      end
      
      if @books_map.include?(book_identifier)
        book = @books_map[book_identifier]
        book.update_from_wl_book(wl_book)
        book.save
      else
        create_book_from_wl(wl_book)
      end
    end
    
    redirect_to books_path, :notice => 'Updated books from Amazon Wish List'
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
    @book = Book.new(params[:book])

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
    new_book.save
  end
end
