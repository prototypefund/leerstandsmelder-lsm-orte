# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SubmissionConfig, type: :model do
  it 'has a valid factory' do
    sbc = build(:submission_config)
    puts sbc.inspect
    expect(sbc).to be_valid
  end
end
