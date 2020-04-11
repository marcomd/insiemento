class OrderProduct < ApplicationRecord
  belongs_to :organization
  belongs_to :order
  belongs_to :product
  before_validation :set_organization

  private

  def set_organization
    self.organization ||= order.organization
  end
end
