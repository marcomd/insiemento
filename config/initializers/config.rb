# Put application's parameters into config.yml
CONFIG = ActiveSupport::HashWithIndifferentAccess.new(YAML.load_file("#{Rails.root}/config/config.yml")[Rails.env])
# CONFIG = HashWithIndifferentAccess.new(YAML.load(ERB.new(File.read("#{Rails.root}/config/config.yml")).result)[Rails.env])
