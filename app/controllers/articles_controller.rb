class ArticlesController < ApplicationController
  filter_access_to :all

  cache_sweeper :articles_sweeper

  helper_method :sort_column, :sort_direction
  
  
  # GET /article
  # GET /article.xml
  def index
    @articles = Article.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:per_page => 10, :page => params[:page])
  end

  # GET /article/1
  # GET /article/1.xml
  def show
    @article = Article.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @article }
    end
  end

  # GET /article/new
  # GET /article/new.xml
  def new
    @article = Article.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @article }
    end
  end

  # GET /article/1/edit
  def edit
    @article = Article.find(params[:id])
  end

  # POST /article
  # POST /article.xml
  def create
    @article = Article.new(params[:article])

    respond_to do |format|
      if @article.save
        format.html { redirect_to(@article, :notice => 'Article was successfully created.') }
        format.xml  { render :xml => @article, :status => :created, :location => @article }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /article/1
  # PUT /article/1.xml
  def update
    @article = Article.find(params[:id])

    respond_to do |format|
      if @article.update_attributes(params[:article])
        format.html { redirect_to(@article, :notice => 'Article was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /article/1
  # DELETE /article/1.xml
  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    respond_to do |format|
      format.html { redirect_to(article_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def sort_column
    Article.column_names.include?(params[:sort]) ? params[:sort] : "date"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
  
end
