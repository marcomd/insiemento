class Organization < ApplicationRecord
  include Stateable

  has_many :users, dependent: :destroy
  has_many :courses, dependent: :destroy
  has_many :trainers, dependent: :destroy
  has_many :rooms, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :payments, dependent: :destroy
  has_many :system_logs, dependent: :destroy

  has_many :homepage_features, class_name: 'Homepage::Feature'
  accepts_nested_attributes_for :homepage_features, reject_if: lambda { |obj| obj[:title].blank? }, allow_destroy: true

  has_one_attached :logo, dependent: :destroy

  before_validation :set_default_value

  STATES = { activating: 10, active: 20, suspended: 30}
  enum state: STATES

  include Storext.model
  store_attributes :theme do
    dark_mode         Boolean, default: false
    header_dark       Boolean, default: false
    header_background_color  String, default: '#FFFFFF'
    color             String, default: '#000000'
    primary_color     String, default: '#1976D2'
    secondary_color   String, default: '#424242'
    accent_color      String, default: '#82B1FF'
    info_color        String, default: '#2196F3'
    success_color     String, default: '#4CAF50'
    error_color       String, default: '#FF5252'
    warning_color     String, default: '#FFC107'
  end

  store_attributes :homepage_data do
    title                    String, default: 'STAI CERCANDO UNA PALESTRA?'
    description              String, default: 'Offriamo un servizio innovativo per prenotare i corsi della tua palestra.'
    customer_title           String, default: 'Sei già nostro cliente?'
    customer_description     String, default: 'Registrati per accedere ai servizi che abbiamo riservato a te'
    primary_features_summary String, default: 'Offriamo un servizio completo con gli strumenti più moderni'
    # primary_features         Array, default: []
  end

  def logo_thumbnail
    logo.variant(resize_to_limit: [400, 100]) if logo.present?
  end

  def logo_medium
    logo.variant(resize_to_limit: [800, 200]) if logo.present?
  end

  def homepage_features
    read_attribute(:homepage_features)&.map {|v| Homepage::Feature.new({}.merge(v)) }
  end

  def homepage_features=(ar_homepage_features)
    write_attribute(:homepage_features, ar_homepage_features)
  end

  def homepage_features_attributes=(attributes)
    homepage_features = []
    attributes.each do |index, attrs|
      next if attrs.delete('_destroy') == '1'
      %w[dark].each do |field_name|
        field_value = attrs[field_name]
        field_value = true if field_value == '1'
        field_value = false if field_value == '0'
        attrs[field_name] = field_value
      end
      homepage_features << attrs
    end
    self.homepage_features = homepage_features
  end

  private

  def set_default_value
    self.uuid ||= SecureRandom.uuid
    self.homepage_features = [
        {title: 'Tanti corsi per tutti',
         icon: 'mdi-yoga',
         text: 'Abbiamo pensato ad ognuno di voi per offrirvi tantissimi corsi che coprono diversi orari'},
        {title: 'Istruttori competenti',
         icon: 'mdi-account-star-outline',
         text: 'Avrai a disposizione bravissimi istruttori che lavorano con noi da molti anni.'},
        {title: 'Interfaccia web mobile',
         icon: 'mdi-tablet-cellphone',
         text: 'Puoi prenotare i tuoi corsi con la nostra interfaccia web moderna che si adatta in automatico a tutti i tipi di dispositivi, anche sullo smartphone.'},
        {title: 'Prezzi chiari',
         icon: 'mdi-cash',
         text: 'Una sola tariffa, ci piacciono le cose chiare e semplici.'},
    ] unless self.homepage_features.present?
  end
end
