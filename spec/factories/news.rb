# frozen_string_literal: true

FactoryBot.define do
  factory :news do
    title { 'MyString' }
    body { 'MyText' }
    published { false }
    map { nil }
    user { nil }
  end
end
