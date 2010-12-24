require 'net/http'
require 'open-uri'

class WishListBook
  attr_writer :title
  attr_writer :author
  attr_writer :amazon_product_url
  attr_writer :amazon_wl_cart_url
  attr_writer :amazon_image_url
  attr_writer :amazon_image_original_url
  attr_writer :amazon_image_width
  attr_writer :amazon_image_height
  attr_writer :amazon_strike_price
  attr_writer :amazon_price
  attr_writer :amazon_availability
  attr_writer :amazon_merchant
  attr_writer :amazon_cover_type
  attr_writer :amazon_wl_add_date
  attr_writer :amazon_wl_priority
  attr_writer :amazon_wl_comment
  attr_writer :copies_desired
  attr_writer :copies_received
  attr_reader :title
  attr_reader :author
  attr_reader :amazon_product_url
  attr_reader :amazon_wl_cart_url
  attr_reader :amazon_image_url
  attr_reader :amazon_image_original_url
  attr_reader :amazon_image_width
  attr_reader :amazon_image_height
  attr_reader :amazon_strike_price
  attr_reader :amazon_price
  attr_reader :amazon_availability
  attr_reader :amazon_merchant
  attr_reader :amazon_cover_type
  attr_reader :amazon_wl_add_date
  attr_reader :amazon_wl_priority
  attr_reader :amazon_wl_comment
  attr_reader :copies_desired
  attr_reader :copies_received
  
  def attribute_hash
    hash_to_return = {}
    self.instance_variables.each do |var|
      hash_to_return[var.to_s.gsub("@","")] = self.instance_variable_get(var)
    end
    return hash_to_return
  end
end

class AmazonWishListFetcher

  @@books = Array.new

  def get_local(page)
    path = "/Users/marshall/Documents/rails/bookdrive/public/wishlist/wl" + page.to_s + ".html"
    if ! File.exists?(path)
      return ''
    end
    puts "Loading from cache: " + path
    f = File.open(path, "r")
    f.read
  end

  def get_remote(page)
    url = "http://www.amazon.com/registry/wishlist/1WJWNVAVRKJVO?reveal=all&filter=all&sort=universal-title&layout=standard&page=" + page.to_s
    puts 'Getting Remote URL: ' + url
    html = Net::HTTP.get_response(URI.parse(url)).body.force_encoding("ISO-8859-1").encode('UTF-8')
    
    if ENV['RAILS_ENV'] == 'development'
      file = File.new("/Users/marshall/Documents/rails/bookdrive/public/wishlist/wl" + page.to_s + ".html", File::WRONLY|File::TRUNC|File::CREAT, 0644)
      file.puts html
      file.close
    end
    
    html
  end

  def parse_wl_page(page = 1)
  
    if ENV['RAILS_ENV'] == 'development'
      html = get_local(page)
      if html.length < 100
        html = get_remote(page)
      end
    else
      html = get_remote(page)
    end

    parse_items(html.force_encoding('UTF-8'))

    return html.match(/<a href="[^"]+"><span>Next/)
  end


  def parse_items(html)
    html.scan(/<tbody\sname=\"item.+?<\/tbody>/m) do |item|
      book = parse_item(item)
      @@books.push( book )
    end

  end


  def parse_item(item)
  
    book = WishListBook.new

    matches = item.match(/<img src="(http:.+jpg)" width="(\d+)" alt=".+?" height="(\d+)"/)
    if matches && matches.length > 0
      book.amazon_image_url, book.amazon_image_width, book.amazon_image_height = matches[1,3]
      book.amazon_image_original_url = book.amazon_image_url.sub(/(.+I\/[^\.]+)\..+/,'\1.jpg')
      book.amazon_image_url.sub!(/_PIsitb-.+?,-[\d]+/,'')
    end

    matches = item.match(/<span class="small productTitle"><strong>\s*<a href="(.+?)">(.+?)</m)
    if matches && matches.length > 0
      book.amazon_product_url, book.title = matches[1,2]
      book.amazon_product_url.sub!(/ref=wl_it_dp_v(?:\/[\d\-]+)?/,'')
    end

    matches = item.match(/<div class="lineItemPart">\s*<span class="authorPart">by ([^\n]+?)\s*<\/span>(?:\((.+?)\))?</m)
    if matches && matches.length > 0
      book.author = matches[1].encode('UTF-8')
      if matches[2] != nil
        book.amazon_cover_type = matches[2].encode('UTF-8')
      end
    end

    matches = item.match(/(?:<span class="strikeprice">\$([\d\.]+)<\/span>)?<span class="wlPriceBold" name="price\.[^"]+"><strong>\$([\d\.]+)<\/strong><\/span>/m)
    if matches && matches.length > 0
      book.amazon_strike_price = matches[1].to_f
      book.amazon_price = matches[2].to_f
    end

    matches = item.match(/<span class="commentBlock wlAvailability">(.+?)<\/span><span class="commentBlock wlLiMerchant" name="merchant.+?">(.+?)<\/span>/m)
    if matches && matches.length > 0
      book.amazon_availability, book.amazon_merchant = matches[1,2]
      book.amazon_availability.sub!(/\s*<span class=\"wlAvailOrange\">This title will be released on (.+?)\.<\/span><br \/>Pre-order now!/,'\1')
      book.amazon_availability.sub!(/\s*<span class="wlAvailOrange">(Usually ships within .+?).<\/span><br \/>/,'\1')
      book.amazon_availability.sub!(/\s*<span class="wlAvailRed wlLiAvailability">(Temporarily out of stock).<\/span>.+/,'\1')
      book.amazon_availability.sub!(/\s*<span class="wlAvailOrange">In stock on (.+)\.<\/span><br \/>.+/,'\1')
      book.amazon_availability.sub!(/\.$/,'')
      book.amazon_merchant.sub!(/Offered by /,'')
    end

    matches = item.match(/<span class="commentBlock"><nobr>Added (.+?)<\/nobr><\/span>/)
    if matches && matches.length > 0
      book.amazon_wl_add_date = matches[1]
    end

    matches = item.match(/<span class="quantityValueText">(\d+)<\/span>/)
    if matches && matches.length > 0
      book.copies_desired = matches[1].to_i
    end

    matches = item.match(/<span class="recQuantityValueText">(\d+)<\/span>/)
    if matches && matches.length > 0
      book.copies_received = matches[1].to_i
    end

    matches = item.match(/<span class="priorityValueText">(\S+)<\/span>/m)
    if matches && matches.length > 0
      book.amazon_wl_priority = matches[1]
    else
      matches = item.match(/PRIORITY<\/span><br\/>(.+?)<\/td>/m)
      if matches && matches.length > 0
        book.amazon_wl_priority = matches[1]
      end
    end
    
    matches = item.match(/<span class="wlProductInfoRow wlBuyButton"><a href="(.+?)(?:&amp;session-id=[\d\-]+)?">/)
    if matches && matches.length > 0
      book.amazon_wl_cart_url = 'http://www.amazon.com' + matches[1]
      book.amazon_wl_cart_url.sub!(/ref=cm_wl_addtocart_v\/[\d\-]+/,'')
      book.amazon_wl_cart_url.sub!(/offeringID.1=.+?\&amp;/,'')
    end
    
    matches = item.match(/<span class="commentValueText">([^<]+)<\/span>/)
    if matches && matches.length > 0
      book.amazon_wl_comment = matches[1]
    end

    return book
  
  end

  def fetch_wish_list
    
    page = 1
    last_page = nil
    while page != nil && (last_page == nil || page <= last_page) do
      next_page = parse_wl_page(page)
      page = next_page ? page + 1 : nil
    end
  end

  def get_updated_wl_books
    fetch_wish_list()
    @@books
  end

end
