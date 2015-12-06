class Detail < ActiveRecord::Base
  belongs_to :abra_notice
  validates_presence_of :abra_notice_id, :key, :value
end
