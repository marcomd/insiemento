class Trainer < ApplicationRecord
  has_and_belongs_to_many :courses

  def full_name
    [firstname, lastname].join(' ')
  end
end
