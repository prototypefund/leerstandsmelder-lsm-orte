# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Role, type: :model do
  it 'has a valid factory' do
    expect(build(:role)).to be_valid
  end
end
