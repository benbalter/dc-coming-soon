class Ward < ActiveRecord::Base
  has_many :ancs, -> { order(:name) }
  has_many :postings, :through => :ancs
end
