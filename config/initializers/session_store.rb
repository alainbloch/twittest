# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_twitter_clone_session',
  :secret      => 'ea0c4a5467f04e93fa43f3e46238e958e98a2f70996e86b11573094e69673ec039070587d1fc40616ab4172d1e7af6c3b37b42e735bfe8d2755b759b038a469b'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
