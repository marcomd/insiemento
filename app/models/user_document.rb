class UserDocument < ApplicationRecord
  include Stateable

  belongs_to :organization
  belongs_to :user_document_model
  belongs_to :user

  before_validation :set_default

  validates_presence_of :title, :body, :state

  enum state: {
      draft:                  10, # Write the text...
      sending:                20, # The text is ready, it will be sent to otp service
      working:                30, # Sent to otp service
      created:                40,
      notified:               50,
      signing:                60,
      signed:                 70,
      completed:             100,
  }, _suffix: true

  include AASM
  aasm :state, column: :state, enum: true do
    state :draft, initial: true
    state :sending, :working, :created, :notified, :signing, :signed, :completed

    event :send_to_otpservice do
      transitions from: :draft, to: :sending,
                  if: [:body],
                  success: :create_dossier_on_otpservice
    end

    event :cancel_sending do
      transitions from: :sending, to: :draft
    end

    event :work do
      transitions from: :sending, to: :working,
                  if: [:body]
    end

    event :otpservice_created do
      transitions from: [:sending, :working], to: :created
    end

    event :complete do
      transitions to: :completed
    end
  end

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
    if user_document_model
      self.title = user_document_model.title unless title.present?
      self.body = user_document_model.body unless body.present?
    end
  end
end
