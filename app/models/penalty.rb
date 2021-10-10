class Penalty < ApplicationRecord
  include Stateable

  belongs_to :organization
  belongs_to :category
  belongs_to :course, optional: true

  enum state: {
    active:                 10,
    suspended:              20,
  }, _suffix: true
end
