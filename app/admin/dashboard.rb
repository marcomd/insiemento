ActiveAdmin.register_page 'Dashboard' do
  controller do
    def index
      @per_page = 10
      @users = User.with_expired_medical_certificate(1.month.from_now)
    end
  end

  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  content title: proc { I18n.t('active_admin.dashboard') } do
    columns do
      column do
        panel(I18n.t('activeadmin.dashboard.users_with_expiring_medical_certificate'), class: 'users_with_expired_medical_certificate') do
          paginated_collection(users.page(params[:page]).per(per_page),
                               entry_name: User.model_name.human,
                               entries_name: User.model_name.human(count: 2),
                               download_links: false) do
            table_for(collection, sortable: false) do
              column(:id)                   { |obj| link_to obj.id, [:admin, obj] }
              column(:firstname)
              column(:lastname)
              column(:state) { |obj| status_tag_for obj }
              column(:medical_certificate_expire_at) do |obj|
                if obj.medical_certificate_expire_at
                  css_class = obj.medical_certificate_expire_at < Time.zone.today ? 'red' : ''
                  span(I18n.localize(obj.medical_certificate_expire_at, format: :long), class: css_class)
                end
              end
              column(:days_before_expiration) { |obj| (obj.medical_certificate_expire_at - Time.zone.today).to_i }
              column('') { |obj| link_to t('activeadmin.dashboard.show'), [:admin, obj] }
            end
          end
          span I18n.t('activeadmin.dashboard.no_users_with_expiring_medical_certificate') if users.empty?
        end
      end
      column do
        preview_period = Time.zone.today.beginning_of_month..(Time.zone.today + 180).end_of_month
        line_chart User.where(medical_certificate_expire_at: preview_period).group_by_month(:medical_certificate_expire_at).count, title: 'Scadenze nei prossimi mesi'
      end
    end
    columns do
      column do
        if current_admin_user.is_root?
          Organization.all.each do |organization|
            render partial: 'admin/dashboard/grouped_users', locals: { organization: organization }
          end
        else
          organization = current_admin_user.organization
          render partial: 'admin/dashboard/grouped_users', locals: { organization: organization }
        end
      end
    end
  end
end
