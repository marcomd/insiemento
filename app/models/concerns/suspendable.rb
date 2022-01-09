# This concern is appliable on models with state enum with values: :active, :suspended
module Suspendable
  extend ActiveSupport::Concern

  def may_activate?
    suspended?
  end

  def activate!
    self.update state: :active
  end

  def may_pause?
    active?
  end

  def pause!
    self.update state: :suspended
  end
end
