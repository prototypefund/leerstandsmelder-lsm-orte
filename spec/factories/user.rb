# frozen_string_literal: true

FactoryBot.define do
  sequence :email do |n|
    "user#{n}@example.com"
  end
  sequence :nickname do |n|
    "nick#{n}"
  end

  factory :user do
    email
    nickname
    password { 'password12345' }
    password_confirmation { 'password12345' }
    confirmed_at { DateTime.now }
    group
    after(:create, &:confirm)
    trait :changed do
      email { 'new@example.com' }
    end
  end

  factory :admin_user, class: User do
    # TODO: cancancan
    email
    password { 'password12345' }
    password_confirmation { 'password12345' }
    confirmed_at { DateTime.now }
    group
    after(:create) { |user| user.add_role(:admin) }
  end
end
