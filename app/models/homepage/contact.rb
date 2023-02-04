module Homepage
  class Contact < VirtualTable
    attr_accessor :title, :icon, :text, :dark, :color

    def initialize(attr = {})
      @title  = attr[:title] || attr['title']
      @icon   = attr[:icon]  || attr['icon']
      @text   = attr[:text]  || attr['text']
      @dark   = attr[:dark]  || attr['dark']
      @color  = attr[:color] || attr['color']
    end

    validates :title, :icon, :text, presence: true

    # Overrides the virtual table method
    # def attributes
    #   [:title, :icon, :description].map do |a|
    #     [a, send(a)]
    #   end.to_h
    # end
  end
end
