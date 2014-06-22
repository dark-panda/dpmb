
Rails.application.config.to_prepare do
  $LIBRARY = Dpmb::Library.new($SITE_SETTINGS.library)
end

