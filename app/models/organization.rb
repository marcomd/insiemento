class Organization < ApplicationRecord
  include Stateable

  has_many :users, dependent: :destroy
  has_many :admin_users, dependent: :destroy
  has_many :courses, dependent: :destroy
  has_many :trainers, dependent: :destroy
  has_many :rooms, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :payments, dependent: :destroy
  has_many :system_logs, dependent: :destroy
  has_many :course_schedules
  has_many :course_events

  has_many :homepage_features, class_name: 'Homepage::Feature'
  has_many :homepage_contacts, class_name: 'Homepage::Contact'
  has_many :homepage_socials, class_name: 'Homepage::Social'
  accepts_nested_attributes_for :homepage_features, reject_if: lambda { |obj| obj[:title].blank? }, allow_destroy: true
  accepts_nested_attributes_for :homepage_contacts, reject_if: lambda { |obj| obj[:title].blank? }, allow_destroy: true
  accepts_nested_attributes_for :homepage_socials, reject_if: lambda { |obj| obj[:title].blank? }, allow_destroy: true

  has_one_attached :logo, dependent: :destroy
  has_one_attached :image, dependent: :destroy
  has_many_attached :images, dependent: :destroy

  before_validation :set_default_value

  STATES = { activating: 10, active: 20, suspended: 30 }
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
    homepage_title                    String, default: 'STAI CERCANDO UNA PALESTRA?'
    homepage_description              String, default: 'Offriamo un servizio innovativo per prenotare i corsi della tua palestra.'
    homepage_customer_title           String, default: 'Sei già nostro cliente?'
    homepage_customer_description     String, default: 'Registrati per accedere ai servizi che abbiamo riservato a te'
    homepage_features_title           String, default: 'Caratteristiche'
    homepage_features_summary         String, default: 'Offriamo un servizio completo con gli strumenti più moderni'
    homepage_bio_title                String, default: 'La nostra storia'
    homepage_bio_description          String, default: 'Siamo presenti sul territorio da diversi anni, esperienza e passione per offrire un servizio di qualità e corsi di tendenza. Attenzione ai dettagli ma soprattutto alle esigenze dei nostri clienti.'
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

  def homepage_contacts
    read_attribute(:homepage_contacts)&.map {|v| Homepage::Contact.new({}.merge(v)) }
  end

  def homepage_contacts=(ar_homepage_contacts)
    write_attribute(:homepage_contacts, ar_homepage_contacts)
  end

  def homepage_contacts_attributes=(attributes)
    homepage_contacts = []
    attributes.each do |index, attrs|
      next if attrs.delete('_destroy') == '1'
      %w[dark].each do |field_name|
        field_value = attrs[field_name]
        field_value = true if field_value == '1'
        field_value = false if field_value == '0'
        attrs[field_name] = field_value
      end
      homepage_contacts << attrs
    end
    self.homepage_contacts = homepage_contacts
  end

  def homepage_socials
    read_attribute(:homepage_socials)&.map {|v| Homepage::Social.new({}.merge(v)) }
  end

  def homepage_socials=(ar_homepage_socials)
    write_attribute(:homepage_socials, ar_homepage_socials)
  end

  def homepage_socials_attributes=(attributes)
    homepage_socials = []
    attributes.each do |index, attrs|
      next if attrs.delete('_destroy') == '1'
      %w[dark].each do |field_name|
        field_value = attrs[field_name]
        field_value = true if field_value == '1'
        field_value = false if field_value == '0'
        attrs[field_name] = field_value
      end
      homepage_socials << attrs
    end
    self.homepage_socials = homepage_socials
  end

  # def homepage_images
  #   read_attribute(:images)&.map {|v| Homepage::Social.new({}.merge(v)) }
  # end
  #
  # def homepage_images_attributes=(attributes)
  #   homepage_images = []
  #   attributes.each do |index, attrs|
  #     next if attrs.delete('_destroy') == '1'
  #     %w[dark].each do |field_name|
  #       field_value = attrs[field_name]
  #       field_value = true if field_value == '1'
  #       field_value = false if field_value == '0'
  #       attrs[field_name] = field_value
  #     end
  #     homepage_images << attrs
  #   end
  #   self.images = homepage_images
  # end

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
    self.homepage_contacts = [{icon:'mdi-map-marker-outline', title: 'Indirizzo', text: 'Via...'},
                              {icon:'mdi-cellphone', title: 'Telefono', text: 'N. telefono'},
                              {icon:'mdi-email', title: 'Email', text: 'Email contatto'}] unless self.homepage_contacts.present?
    self.homepage_socials = [{icon:'mdi-facebook', title: 'Facebook', text: 'https://facebook.com'},
                             {icon:'mdi-twitter', title: 'Twitter', text: 'https://twitter.com'},
                             {icon:'mdi-instagram', title: 'Instagram', text: 'https://instagram.com'},
                             {icon:'mdi-linkedin', title: 'Linkedin', text: 'https://linkedin.com'}] unless self.homepage_socials.present?
  end
end
