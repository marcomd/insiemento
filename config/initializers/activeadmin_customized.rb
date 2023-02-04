module ActiveAdmin
  module Views
    # Custom footer
    # lib/active_admin/views/footer.rb
    class Footer < Component
      def build(namespace)
        @namespace = namespace

        div(id: 'footer') do
          ar_footer = [CONFIG.dig(:application, :name),
                       "#{I18n.t('activeadmin.footer.env')} <b>#{Rails.env}</b>",
                       "#{I18n.t('activeadmin.footer.version')} <b>#{CONFIG.dig(:application, :version)}</b>",
                       "#{I18n.t('activeadmin.footer.last_update')} <b>#{CONFIG.dig(:application, :updated_at)}</b>"]
          ar_footer << "#{I18n.t('activeadmin.footer.last_commit')} <b>#{`git rev-parse HEAD`[0..6]}</b>" if Rails.env.development?
          # if Rails.env.staging?
          #   ar_footer << "#{I18n.t('activeadmin.footer.last_commit')} <b>#{ProjectDiagnostic.get_last_deployed_commit}</b>"
          # end
          para(ar_footer.join(', ').html_safe)
          if Rails.env.production? || Rails.env.production_itw?
            para(image_tag('logo_200.png', size: '50x50'))
            para(''.gsub(/^              /, '').html_safe)
          else
            para(image_tag('logo_200.png', size: '50x50'))
          end
        end
      end
    end

    class AttributesTable < ActiveAdmin::Component
      def as_image_row(*args)
        title   = args[0]
        options = args.extract_options!
        classes = [:row]
        if options[:class]
          classes << options[:class]
        elsif title.present?
          classes << "row-#{title.to_s.parameterize(separator: '_')}"
        end
        options[:class] = classes.join(' ')

        @table << tr do
          th do
            header_content_for(title)
          end
          @collection.each do |record|
            td do
              image_tag((record.send(title).presence || 'logo_placeholder.png'), options)
            end
          end
        end
      end

      def color_row(*args)
        title = args[0]

        @table << tr do
          th do
            header_content_for(title)
          end
          @collection.each do |record|
            td do
              content_tag(:div, ''.html_safe <<
                  content_tag(:span, ' ', style: "background-color: #{record.send(title)}; padding: 4px 10px; border: 1px solid #ddd; border-radius: 8px;") <<
                  content_tag(:span, record.send(title), style: 'font-family: Courier; margin-left: 10px;'))
            end
          end
        end
      end
    end
  end

  # Used to show error message of the destroy action
  # It generates this deprecation warning:
  # DEPRECATION WARNING: Initialization autoloaded the constants ApplicationHelper, EmailHelper, VueHelper, DeviseHelper, ApplicationController, InheritedResources::Base, ActionText::ContentHelper, and ActionText::TagHelper
  unless Rails.env.test?
    class BaseController
      private

      def flash_interpolation_options
        options = {}

        options[:resource_errors] =
          if resource && resource.errors.any?
            "#{resource.errors.full_messages.to_sentence}."
          else
            ''
          end

        options
      end
    end
  end
end
