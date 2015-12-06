class Ward < ActiveRecord::Base
  has_many :ancs, -> { order(:name) }
  has_many :abra_notices, :through => :ancs
end
