require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(*Rails.groups)

module Adminb
  class Application < Rails::Application
    config.i18n.default_locale = :ru
    config.autoload_paths << "#{config.root}/lib"
    config.autoload_paths << "#{config.root}/app/validators"
    config.active_record.schema_format = :sql
    config.assets.paths << Rails.root.join("app", "assets", "fonts")
  end
end

template = ERB.new(File.new("#{Rails.root}/config/config.yml").read)
config = YAML.load(template.result(binding))
APP_CONFIG = config["default"].merge(config[Rails.env] || {})
