module Stateable
  extend ActiveSupport::Concern

  class_methods do
    def localized_states
      states.map { |k, v| [I18n.t!("activerecord.attributes.#{self.name.underscore}.states.#{k}"), v] }
    end
  end

end
