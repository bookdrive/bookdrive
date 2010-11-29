class DownloadEvent < ActiveRecord::Base
  belongs_to :donor
  belongs_to :gift
end
