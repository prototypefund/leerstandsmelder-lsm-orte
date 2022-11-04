# frozen_string_literal: true

FactoryBot.define do
  factory :role do
    name { 'MyRole' }
    resource_id {}
    resource_type {}
    trait :resource do
      resource_type { Map }
    end
  end
end
