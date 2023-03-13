# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'news/show', type: :view do
  before(:each) do
    assign(:news, FactoryBot.create(:news, title: 'TitleNews'))
  end

  it 'renders attributes in <p>' do
    render
  end
end
