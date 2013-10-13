# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
#SampleApp::Application.config.secret_key_base = '97c10d6b21ccefcbb3e3042223914e7d0a7f74d23fe3637f46236a00ae11acec625a40283cf4f23365240d73d749545c29a47a7d7ca92165bca76cad8a940fa2'

# Create a dynamic token
require 'securerandom'

def secure_token
	token_file = Rails.root.join('.secret')
	
	if File.exist?(token_file) 
		# Use the existing token
		File.read(token_file).chomp
	else
		# Generate a new token and store it in token_file
		token = SecureRandom.hex(64)
		File.write(token_file, token)
		token
	end
end

SampleApp::Applicaton.config.secret_key_base = secure_token










