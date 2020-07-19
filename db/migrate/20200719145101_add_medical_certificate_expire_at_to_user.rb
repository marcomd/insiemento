class AddMedicalCertificateExpireAtToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :medical_certificate_expire_at, :date
  end
end
