class News < ApplicationRecord
  include Stateable
  belongs_to :organization

  before_validation :set_default
  before_save :set_current_state

  enum state: {
    draft: 10, # Write the text...
    active: 20, # The news is published
    expired: 100  # The news is no more shown
  }, _suffix: true

  enum news_type: {
    critical: 1,
    warning: 2,
    info: 3,
    success: 4,
    happy: 5,
    kidding: 6,
    sad: 7,
    disconcert: 8,
    love: 9,
    angry: 10,
    tech: 11,
    premium: 12
  }, _suffix: true

  def icon
    "mdi-#{
    case news_type
    when 'critical'   then 'alert'
    when 'info'       then 'information-outline'
    when 'warning'    then 'alert-decagram-outline'
    when 'success'    then 'thumb-up-outline'
    when 'happy'      then 'emoticon-outline'
    when 'kidding'    then 'emoticon-lol-outline'
    when 'sad'        then 'emoticon-cry-outline'
    when 'disconcert' then 'emoticon-frown-outline'
    when 'love'       then 'emoticon-kiss-outline'
    when 'angry'      then 'emoticon-angry-outline'
    when 'tech'       then 'monitor-cellphone'
    when 'premium'    then 'star'
    else
      news_type
    end
  }"
  end

  def color
    case news_type
    when 'critical'  then 'red'
    when 'info'      then 'blue'
    when 'warning'   then 'orange'
    when 'success'   then 'green'
    when 'disconcert' then 'purple'
    when 'love'      then 'red'
    when 'angry'     then 'red'
    when 'tech'      then '#555555'
    when 'premium'   then '#FFCC00'
    else
      'primary'
    end
  end

  private

  def set_current_state(date=Time.zone.today)
    self.state = 'expired' if state == 'active' && expire_on < date
    self.state = 'active' if state == 'expired' && expire_on >= date
  end

  def set_default
    self.state ||= :draft
    self.news_type ||= :info
    self.expire_on ||= Time.zone.today + 1.week
    self.dark_style = true if dark_style.nil?
    self.public = true if public.nil?
    self.private = true if private.nil?
  end
end
