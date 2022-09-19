module VueHelper
  def vue(component:, props: {})
    content_tag :div do
      content_tag :div, nil,
                  id: "#{component}-vue-wrapper",
                  'data-props': props.to_json,
                  'data-locale': I18n.locale,
                  'data-i18n': translations(component),
                  'data-env': Rails.env
      # 'data-rollbar-token': rollbar_token,
    end
  end

  private

  def translations(component)
    translations_json = {}
    I18n.available_locales.each do |locale|
      I18n.with_locale(locale) do
        translations_json[locale] = t("ui.#{component.underscore}")
      end
    end
    translations_json.to_json
  end

  # def rollbar_token
  #   Rollbar.configuration.js_options[:accessToken] unless Rails.env.development? || Rails.env.test?
  # end
end
