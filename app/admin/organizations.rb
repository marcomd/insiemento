ActiveAdmin.register Organization do
  menu parent: 'platform_management', if: proc{ can?(:update, Organization) }

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :payoff, :domain, :email, :phone, :state, :logo,
                :dark_mode,
                :header_dark,
                :header_background_color,
                :color,
                :primary_color,
                :secondary_color,
                :accent_color,
                :info_color,
                :success_color,
                :error_color,
                :warning_color
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :email, :phone, :theme, :state]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  index do
    selectable_column
    id_column
    column(:name)
    column(:email)
    column(:phone)
    column(:state) {|obj| span obj.state, class: "status_tag #{obj.state}" }
    actions
  end

  filter :name
  filter :email
  filter :phone
  filter :state       , as: :select, collection: CourseEvent.localized_states
  filter :created_at
  filter :updated_at

  show do |organization|
    columns do
      column do
        attributes_table do
          row(:name)
          row(:payoff)
          row(:domain)
          row(:email)
          row(:phone)
          row(:state) {|obj| span obj.state, class: "status_tag #{obj.state}" }
          row(:created_at)
          row(:updated_at)
        end
      end
      column do
        attributes_table do
          as_image_row(:logo, style: 'height: 100px')
          as_image_row(:logo_thumbnail, style: 'height: 50px')
          row :dark_mode
          row :header_dark
          color_row :header_background_color
          color_row :color
          color_row :primary_color
          color_row :secondary_color
          color_row :accent_color
          color_row :info_color
          color_row :success_color
          color_row :error_color
          color_row :warning_color
        end
      end
    end
  end

  form do |f|
    columns do
      column do
        f.inputs do
          f.input :name
          f.input :payoff
          f.input :domain
          f.input :email
          f.input :phone
          f.input :state #, collection: Organization::STATES
        end
      end
      column do
        f.inputs do
          f.input :logo, as: :file, hint: f.object.logo.present? ? image_tag(f.object.logo, height: '50px') : ''
          Organization.stored_attributes[:theme].each do |accessor|
            f.input accessor,
                    as: (Organization.storext_definitions[accessor][:type].name.include?('Boolean') ? :boolean : :minicolors_picker ),
                    required: false
          end
        end
      end
    end

    f.actions
  end

end
