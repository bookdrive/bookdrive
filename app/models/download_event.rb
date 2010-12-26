class DownloadEvent < ActiveRecord::Base
  belongs_to :donor, :counter_cache => 'downloads_count'
  belongs_to :gift
end
