class PostMortem < ApplicationRecord
  belongs_to :stock
  has_one :user, through: :stock
end
