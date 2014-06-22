
Rails.application.config.to_prepare do
  $SITE_SETTINGS = Hashie::Mash.new(
    YAML.load(File.read(File.join(Rails.root, 'config', 'site_settings.yml'))),
    nil
  ).deep_freeze
end

