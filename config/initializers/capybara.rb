Capybara.configure do |config|
  config.run_server = false
  config.default_driver = :webkit
  config.javascript_driver = :webkit
  config.app_host = 'https://accounts.google.com'
end
