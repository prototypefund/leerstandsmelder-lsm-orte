# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'status/show', type: :view do
  before(:each) do
    @map = FactoryBot.create(:map)
    assign(:status, Status.create!(
                      title: 'Title',
                      description: 'MyText',
                      basic: false,
                      map: @map
                    ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/MyText/)
  end
end
