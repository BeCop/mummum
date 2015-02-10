class Story < ActiveRecord::Base
  mount_uploader :picture, PictureUploader
end
