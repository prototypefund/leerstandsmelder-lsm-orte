require 'exception_notification/rails'

if Rails.env.production? || Rails.env.staging?

  Rails.application.config.middleware.use ExceptionNotification::Rack,
    email: {
      email_prefix:           "[LSM ORTE Backend - #{::Rails.env}] ",
      sender_address:         %{ tech@leerstandsmeldung.de  },
      exception_recipients:   %w{ tech@leerstandsmeldung.de }
  }

end
