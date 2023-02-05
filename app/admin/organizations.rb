ActiveAdmin.register(Organization) do
  menu parent: 'platform_management', if: proc { can?(:update, Organization) }

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :payoff, :domain, :email, :phone, :state, :logo, :image, :analytics_tag,
                :dark_mode, :header_dark,
                :header_background_color, :color, :primary_color, :secondary_color,
                :accent_color, :info_color, :success_color, :error_color, :warning_color,
                :homepage_title, :homepage_description,
                :homepage_customer_title, :homepage_customer_description,
                :homepage_features_title, :homepage_features_summary,
                :homepage_bio_title, :homepage_bio_description,
                homepage_features_attributes: %i[title icon text dark color _destroy],
                homepage_contacts_attributes: %i[title icon text dark color _destroy],
                homepage_socials_attributes: %i[title icon text dark color _destroy],
                images: []
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
    column(:state) { |obj| span obj.state, class: "status_tag #{obj.state}" }
    actions
  end

  filter :name
  filter :email
  filter :phone
  filter :state, as: :select, collection: CourseEvent.localized_states
  filter :analytics_tag
  filter :created_at
  filter :updated_at

  show do |organization|
    columns do
      column do
        attributes_table do
          row(:uuid)
          row(:name)
          row(:payoff)
          row(:domain)
          row(:email)
          row(:phone)
          row(:state) { |obj| span obj.state, class: "status_tag #{obj.state}" }
          row(:analytics_tag)
          row(:created_at)
          row(:updated_at)
        end
      end
      column do
        # Only to add a column
      end
    end
    columns do
      column do
        attributes_table do
          as_image_row(:logo, height: '100px')
          as_image_row(:image, height: '100px')
          row(:images) do
            html = ''
            organization.images.each do |image|
              html << image_tag(image, height: '100px')
            end
            html.html_safe
          end

          # as_image_row(:logo_thumbnail, style: 'height: 50px') # Vips image processing required
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
      column do
        content_tag(:iframe, src: "#{root_url}?uuid=#{organization.uuid}", frameborder: '0', style: 'display:block; position: relative; height: 600px; width: 100%;') do
          content_tag(:div, 'No iframe supported')
        end
      end
    end
  end

  form html: { multipart: true } do |f|
    columns do
      column do
        f.inputs('Dati principali') do
          f.input(:name)
          f.input(:payoff)
          f.input(:domain)
          f.input(:email)
          f.input(:phone)
          f.input(:state) # , collection: Organization::STATES
          f.input(:analytics_tag)
        end
      end
      column do
        # Only to add a column
      end
    end
    columns do
      column do
        f.inputs('Aspetto estetico') do
          f.input(:logo, as: :file, hint: f.object.logo.present? ? image_tag(f.object.logo, height: '50px') : '')
          f.input(:image, as: :file, hint: f.object.image.present? ? image_tag(f.object.image, height: '50px') : '')
          f.input(:images, as: :file, hint: f.object.images.present? ? f.object.images.map { |image| image_tag(image, height: '50px') }.join(' ').html_safe : '', input_html: { multiple: true })
          Organization.stored_attributes[:theme].each do |accessor|
            f.input(accessor,
                    as: (Organization.storext_definitions[accessor][:type].name.include?('Boolean') ? :boolean : :minicolors_picker),
                    required: false)
          end
        end
      end
      column do
        f.inputs('Homepage') do
          f.semantic_errors(*f.object.errors.attribute_names)
          f.input(:homepage_title)
          f.input(:homepage_description, as: :text, input_html: { class: 'autogrow', rows: 5 })
          f.input(:homepage_customer_title)
          f.input(:homepage_customer_description, as: :text, input_html: { class: 'autogrow', rows: 5 })
          f.input(:homepage_features_title)
          f.input(:homepage_features_summary)
          f.has_many(:homepage_features, heading: 'Caratteristiche  ', allow_destroy: true, new_record: true) do |ff|
            ff.input(:title, as: :string)
            ff.input(:icon, as: :string)
            ff.input(:text, as: :text, input_html: { class: 'autogrow', rows: 3 })
            ff.input(:dark, as: :boolean)
            ff.input(:color, as: :string)
          end
          f.input(:homepage_bio_title)
          f.input(:homepage_bio_description)
          f.has_many(:homepage_contacts, heading: 'Contatti  ', allow_destroy: true, new_record: true) do |ff|
            ff.input(:title, as: :string)
            ff.input(:icon, as: :string)
            ff.input(:text, as: :text, input_html: { class: 'autogrow', rows: 3 })
            ff.input(:dark, as: :boolean)
            ff.input(:color, as: :string)
          end
          f.has_many(:homepage_socials, heading: 'Social  ', allow_destroy: true, new_record: true) do |ff|
            ff.input(:title, as: :string)
            ff.input(:icon, as: :string)
            ff.input(:text, as: :text, input_html: { class: 'autogrow', rows: 3 })
            ff.input(:dark, as: :boolean)
            ff.input(:color, as: :string)
          end
        end
      end
    end

    f.actions
  end
end
