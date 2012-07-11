Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook,'158722860929735', '251ba73775343bd4bbc32359ff8ee2f5',:client_options => { :ssl => { :ca_file => "#{Rails.root}/config/ca-bundle.crt" } } 

end