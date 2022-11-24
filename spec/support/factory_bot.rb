# frozen_string_literal: true

# RSpec
# spec/support/factory_boy.rb
RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end

def build_attributes(*args)
  FactoryBot.build(*args).attributes.delete_if do |k, v|
    %w[id created_at updated_at].member?(k)
  end
end
