class Ward < ActiveRecord::Base
  has_many :ancs, -> { order(:name) }
end
