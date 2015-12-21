class LocationPosting < ActiveRecord::Base
  belongs_to :location
  belongs_to :posting, polymorphic: true
end
