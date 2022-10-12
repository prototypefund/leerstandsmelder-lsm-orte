# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin AJAX requests.

# Read more: https://github.com/cyu/rack-cors

# Rails.application.config.middleware.insert_before 0, Rack::Cors do
#   allow do
#     origins 'example.com'
#
#     resource '*',
#       headers: :any,
#       methods: [:get, :post, :put, :patch, :delete, :options, :head]
#   end
# end


# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin AJAX requests.

# Read more: https://github.com/cyu/rack-cors


Rails.application.config.middleware.insert_before 0, Rack::Cors, debug: false do
  allow do
    origins 'http://localhost:8080', '127.0.0.1:8080', 'localhost:8080', 'http://127.0.0.1:8080'
    resource '*', 
      headers: :any,
      methods: :any,
      credentials: true,
      expose: %w[Authorization authorization access-token expiry token-type uid client Access-Control-Allow-Origin]
  end
end

#Rails.application.config.action_controller.forgery_protection_origin_check = false