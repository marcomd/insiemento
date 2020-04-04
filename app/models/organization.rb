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
end
