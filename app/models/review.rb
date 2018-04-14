class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates_presence_of :rating, :description
  validates :rating, inclusion: {in: [1, 2, 3, 4, 5], message: "not a valid rating"}
end