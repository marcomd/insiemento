module ActiveAdmin
  module Views
    # Custom footer
    # lib/active_admin/views/footer.rb
    class Footer < Component

      def build(namespace)
        @namespace = namespace

        div :id => "footer" do
          ar_footer = [CONFIG.dig(:application, :name),
                       "#{I18n.t('activeadmin.footer.env')} <b>#{Rails.env}</b>",
                       "#{I18n.t('activeadmin.footer.version')} <b>#{CONFIG.dig(:application, :version)}</b>",
                       "#{I18n.t('activeadmin.footer.last_update')} <b>#{CONFIG.dig(:application, :updated_at)}</b>"]
          if Rails.env.development?
            ar_footer << "#{I18n.t('activeadmin.footer.last_commit')} <b>#{`git rev-parse HEAD`[0..6]}</b>"
          end
          # if Rails.env.staging?
          #   ar_footer << "#{I18n.t('activeadmin.footer.last_commit')} <b>#{ProjectDiagnostic.get_last_deployed_commit}</b>"
          # end
          para ar_footer.join(', ').html_safe
          if Rails.env.production? || Rails.env.production_itw?
            para image_tag 'logo_50.png'
            para <<GOOGLEANALYTICS.gsub(/^              /, '').html_safe
GOOGLEANALYTICS
          else
            para image_tag 'logo_50.png'
          end
        end
      end
    end
  end
end
