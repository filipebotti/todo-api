# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'

run Rails.application

use Rack::Cors do
	allow do
		origins 'localhost:3000', '127.0.0.1:3000'
		origins 'localhost:4000', '127.0.0.1:4000'
	end

	allow do
		origins '*'
		resource '/public/*', :headers => :any, :methods => :get
	end
end