class Subscription < ApplicationRecord
  belongs_to :organization
  belongs_to :category
  belongs_to :product
  belongs_to :user, optional: true
  before_validation :set_code

  scope :active, -> (date=Time.zone.today) { where('start_on <= ? and end_on > ?', date, date) }
  scope :free, -> { where(user_id: nil) }

  def is_active?(date=Time.zone.today)
    start_on <= date && end_on > date
  end

  private

  def set_code
    self.code = SecureRandom.hex(7)
  end
end
