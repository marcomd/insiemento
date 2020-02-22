module LocaleHelper
  def with_locale(locale)
    old_locale = I18n.locale
    I18n.locale = locale
    yield
  ensure
    I18n.locale = old_locale
  end
end
