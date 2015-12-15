class Anc < ActiveRecord::Base
  belongs_to :ward
  before_validation :set_ward_from_name

  has_many :licensees
  has_many :abra_notices, through: :licensees

  REGEX = /[1-8][A-G]/

  validates_format_of :name, :with => REGEX
  validates_presence_of :ward_id

  extend FriendlyId
  friendly_id :name, use: [:finders]

  private

  def set_ward_from_name
    self.ward = Ward.find_or_create_by :id => name[0]
  end
end
