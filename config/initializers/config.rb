# Put application's parameters into config.yml
CONFIG = ActiveSupport::HashWithIndifferentAccess.new(YAML.load_file(Rails.root.join('config/config.yml'))[Rails.env])
