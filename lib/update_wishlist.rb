require 'net/http'

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
  
  @@book_count = 0
  @@copies_desired = 0
  @@copies_received = 0
  @@dollars_donated = 0
  @@books_complete = 0
  @@books_empty = 0

  def get_local(page)
    url = "http://localhost:3000/wl" + page.to_s + ".html"
    puts 'Getting Local URL: ' + url
    Net::HTTP.get_response(URI.parse(url)).body
  end

  def get_remote(page)
    url = "http://www.amazon.com/registry/wishlist/1WJWNVAVRKJVO/?_encoding=UTF8&filter=all&sort=universal-title&layout=standard&reveal=all&page=" + page.to_s
    puts 'Getting Remote URL: ' + url
    html = Net::HTTP.get_response(URI.parse(url)).body.force_encoding("ISO-8859-1").encode('UTF-8')
    file = File.new("/Users/marshall/Documents/rails/bookdrive/public/wl" + page.to_s + ".html", File::WRONLY|File::TRUNC|File::CREAT, 0644)
    file.puts html
    file.close
    html
  end

  def parse_wl_page(page = 1)
  
    html = get_local(page)
    if html =~ /No route matches/
      html = get_remote(page)
    end
    
    parse_items(html.force_encoding('UTF-8'))

    return html.match(/<a href="[^"]+"><span>Next/)
  end


  def parse_items(html)
    html.scan(/<tbody\sname=\"item.+?<\/tbody>/m) do |item|
      book = parse_item(item)
      @@books.push( book )
      @@book_count += 1
      @@books_empty += 1 if book.copies_received != nil && book.copies_received < 1
      @@books_complete += 1 if book.copies_received != nil && book.copies_desired != nil && book.copies_received >= book.copies_desired
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
    end

    matches = item.match(/<div class="lineItemPart">\s*<span class="authorPart">by ([^\n]+?)\s*<\/span>(?:\((.+?)\))?</m)
    if matches && matches.length > 0
      book.author = matches[1].encode('UTF-8')
      book.amazon_cover_type = matches[2].encode('UTF-8')
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
      @@copies_desired += book.copies_desired
    end

    matches = item.match(/<span class="recQuantityValueText">(\d+)<\/span>/)
    if matches && matches.length > 0
      book.copies_received = matches[1].to_i
      @@copies_received += book.copies_received
      if book.amazon_price != nil
        @@dollars_donated += book.copies_received * book.amazon_price
      end
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

  def cl_run
    fetch_wish_list()
    puts 'Titles: ' + @@book_count.to_s
    puts 'Desired: ' + @@copies_desired.to_s
    puts 'Received: ' + @@copies_received.to_s
    puts 'Dollars: ' + @@dollars_donated.round.to_s
    puts 'Complete: ' + @@books_complete.to_s
    puts 'Empty: ' + @@books_empty.to_s
    
  end
end