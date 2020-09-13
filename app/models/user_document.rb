class UserDocument < ApplicationRecord
  include Stateable

  belongs_to :organization
  belongs_to :user_document_model
  belongs_to :user

  before_validation :set_default

  validates_presence_of :title, :body, :state

  enum state: {
      draft:                  10, # Write the text...
      ready:                  20, # The document is ready to sent to external service
      exporting:              30, # Job is sending document to external service
      exporting_error:        40, # An error was occured during exporting
      exported:               50, # The document has been sent to external service
      signed:                 70, # The document has been signed by signer
      completed:              80, # The signed document has been sent to signer
      expired:                100,# The document is no more valid
  }, _suffix: true

  include AASM
  aasm :state, column: :state, enum: true do
    state :draft, initial: true
    state :ready, :exporting, :exporting_error, :exported, :signed, :completed, :expired

    event :send_to_otpservice do
      transitions from: [:draft, :exporting_error], to: :ready,
                  if: [:body],
                  success: :create_dossier_on_otpservice
    end

    event :not_ready_anymore do
      transitions from: :ready, to: :draft
    end

    event :start_export do
      transitions from: [:ready, :exporting, :exporting_error], to: :exporting,
                  if: [:body]
    end

    event :created_on_otpservice do
      transitions from: [:exporting, :exporting_error], to: :exported
    end

    event :error_on_otpservice do
      transitions from: [:exporting], to: :exporting_error
    end

    # Other states are set by external callbacks
  end

  # Used by User model to get active user document
  scope :active, -> (date=Time.zone.today) { where.not(state: :expired).where('expire_on > ?', date) }
  scope :to_expire, -> (date=Time.zone.today) { where.not(state: :expired).where('expire_on <= ?', date) }


  # def active?(date=Time.zone.today)
  #   expire_on > date
  # end

  def parsed_body
    eval "\"#{body}\""
  end

  def pdf
    pdf = Prawn::Document.new
    pdf.text parsed_body
    pdf.render
  end

  def base64_pdf
    Base64.strict_encode64 pdf
  end

  private

  def today
    Time.zone.today.strftime('%d/%m/%Y')
  end

  def birthdate
    user.birthdate&.strftime('%d/%m/%Y')
  end

  def create_dossier_on_otpservice
    # UserDocumentJob.set(wait: 3.seconds).perform_later(self)
    UserDocumentJob.perform_later(self)
  end

  # Imposta i valori di default dei campi del db prima della creazione
  # Vedi le sottoclassi sti per l'override dei valori
  def set_default
    self.uuid ||= SecureRandom.uuid
    if user_document_model
      self.title = user_document_model.title unless title.present?
      self.body = user_document_model.body unless body.present?
      self.expire_on = Time.zone.now + user_document_model.validity_days.days
    end
  end
end
