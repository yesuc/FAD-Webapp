OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, '532711908907-0bk3ojk7qusq8tb5885bqt13gji7i0jb.apps.googleusercontent.com', 'PEfF6f-sXtqY33iX9qky8uyn'
end
