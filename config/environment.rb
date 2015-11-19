# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
if Rails.application.config.serve_static_assets
  app.middleware.insert_before(::ActionDispatch::Static, ::ActionDispatch::Static, "#{root}/public")
end
