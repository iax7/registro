class Post < ActiveRecord::Base
  validates :author, :title, :content,
            presence: true
end
