# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_MyBank_session',
  :secret      => '6a8941f3217cdacdbb9bdba069444dc715d92f62a9eaf3714c533503fecfb1ba2a746e6150e9f520a6f2bb7be4f5fd174c92c411291bc454ddd05824db9de94f'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
