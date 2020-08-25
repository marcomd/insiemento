class SystemLog < ApplicationRecord
  belongs_to :organization, optional: true
end
