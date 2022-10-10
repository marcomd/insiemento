# See https://pawelurbanek.com/rails-presenter-pattern

module Presentable
  def decorate
    "#{self.class}Presenter".constantize.new(self)
  end
end