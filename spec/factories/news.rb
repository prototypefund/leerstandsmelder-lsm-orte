# frozen_string_literal: true

FactoryBot.define do
  factory :news do
    title { 'MyString' }
    body { 'MyText' }
    published { false }
    # news_map { create(:map) }
    user { create(:user) }
    locales { ['de'] }
  end
end
