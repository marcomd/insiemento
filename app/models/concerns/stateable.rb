module Stateable
  extend ActiveSupport::Concern

  class_methods do
    def localized_states
      states.map { |k, v| [I18n.t!("activerecord.attributes.#{name.underscore}.states.#{k}"), v] }
    end
  end

  def localized_state
    I18n.t!("activerecord.attributes.#{self.class.name.underscore}.states.#{state}")
  end
end
