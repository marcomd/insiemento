class UserDocumentModel < ApplicationRecord
  include Stateable

  belongs_to :organization
  has_many :user_documents

  before_validation :set_default

  validates_presence_of :title, :body, :state, :validity_days

  enum state: {
      active:                 20,
      suspended:              30,
  }, _suffix: true

  private

  # Imposta i valori di default dei campi del db prima della creazione
  # Vedi le sottoclassi sti per l'override dei valori
  def set_default
    self.state ||= :active
    self.validity_days  ||= 14
  end
end
