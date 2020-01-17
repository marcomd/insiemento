json.extract! customer, :id, :organization_id,
              :email, :fiscal_code, :first_name, :last_name, :business_name,
              :birthdate, :sex,
              :document_number, :customer_type, :language, :category, :phone_prefix, :phone,
              :address, :cap, :ok_marketing, :category, :origin,
              :country_of_birth_id, :country_of_residence_id, :citizenship_id,
              :created_at, :updated_at
json.pending_order_uuid customer.pending_order_uuid if customer.pending_order_uuid
