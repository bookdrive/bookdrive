# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101226223753) do

  create_table "articles", :force => true do |t|
    t.string   "title"
    t.text     "summary"
    t.string   "source"
    t.string   "url"
    t.date     "date"
    t.string   "author"
    t.text     "embed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "articles", ["title"], :name => "index_articles_on_title"

  create_table "books", :force => true do |t|
    t.string   "title",                                                                                       :null => false
    t.string   "author",                                                                                      :null => false
    t.decimal  "amazon_price",                              :precision => 10, :scale => 2
    t.integer  "copies_desired",                                                           :default => 0
    t.integer  "copies_received",                                                          :default => 0
    t.boolean  "copies_complete",                                                          :default => false
    t.string   "amazon_product_url",        :limit => 1000
    t.string   "amazon_wl_cart_url",        :limit => 1000
    t.string   "amazon_image_url",          :limit => 1000
    t.integer  "amazon_image_width"
    t.integer  "amazon_image_height"
    t.string   "amazon_cover_type"
    t.date     "amazon_wl_add_date"
    t.string   "source"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "amazon_strike_price",                       :precision => 10, :scale => 2
    t.string   "amazon_availability"
    t.string   "amazon_merchant"
    t.string   "amazon_wl_priority"
    t.decimal  "dollars_donated",                           :precision => 10, :scale => 2
    t.integer  "copies_delivered",                                                         :default => 0
    t.string   "amazon_image_original_url", :limit => 1000
    t.integer  "user_id"
    t.integer  "books_in_set",                                                             :default => 1
    t.integer  "total_book_count",                                                         :default => 0
    t.text     "amazon_wl_comment"
  end

  add_index "books", ["author"], :name => "index_books_on_author"
  add_index "books", ["title"], :name => "index_books_on_title"

  create_table "copies", :force => true do |t|
    t.integer  "book_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "donors", :force => true do |t|
    t.string   "order_number"
    t.string   "zip"
    t.string   "donor_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "full_name"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.boolean  "cd_requested",    :default => false
    t.string   "country"
    t.string   "email"
    t.integer  "downloads_count", :default => 0
  end

  add_index "donors", ["order_number"], :name => "index_donors_on_order_number"

  create_table "download_events", :force => true do |t|
    t.integer  "donor_id"
    t.integer  "gift_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ip_address"
  end

  create_table "gifts", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
  end

  create_table "questions", :force => true do |t|
    t.string   "question"
    t.text     "answer"
    t.string   "category"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "questions", ["question"], :name => "index_questions_on_question"

  create_table "schools", :force => true do |t|
    t.string   "name"
    t.string   "level"
    t.decimal  "proficiency"
    t.decimal  "lunch_eligibility"
    t.integer  "students"
    t.string   "website_url"
    t.string   "greatschools_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "schools", ["name"], :name => "index_schools_on_name"

  create_table "snippets", :force => true do |t|
    t.string   "name"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "password_salt",                       :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "roles_mask"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
