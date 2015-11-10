OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, "344247708995-k0guuk05hjvj2gdh6opidbc375os6o4c.apps.googleusercontent.com", "n3tr5FQPVxhGNACjCPyivofv", {client_options: {ssl: {ca_file: Rails.root.join("cacert.pem").to_s}}}
end
