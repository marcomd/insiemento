class Product < ApplicationRecord
  include Stateable

  belongs_to :organization
  belongs_to :category
  has_many :order_products
  has_many :order, through: :order_products
  has_many :active_subscriptions, -> { active_state }, class_name: 'Subscription'

  before_validation :set_default

  validates_presence_of :product_type, :name, :description, :price_cents, :days
  validates_presence_of :max_accesses_number, if: -> { ['trial', 'consumption'].include? product_type }
  # validates_absence_of :max_accesses_number, if: -> { ['fee'].include? product_type } # Removed validation to define a cap

  enum product_type: { trial: 10, consumption: 20, fee: 30 }, _suffix: true

  enum state: {
      new:                    10,
      active:                 20,
      suspended:              30,
  }, _suffix: true

  monetize :price_cents

  # It uses comma as thousand separator
  ransacker :price, formatter: proc { |v| v.sub(',','.').to_r * 100 } do |parent|
    parent.table[:price_cents]
  end

  private

  # Imposta i valori di default dei campi del db prima della creazione
  # Vedi le sottoclassi sti per l'override dei valori
  def set_default
    self.state ||= :new
    self.days  ||= 365
  end
end
