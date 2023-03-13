# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'status/index', type: :view do
  before(:each) do
    @map = FactoryBot.create(:map, title: 'MyMap')

    assign(:status, [
             Status.create!(
               title: 'Title',
               description: 'MyText',
               basic: false,
               map: @map
             ),
             Status.create!(
               title: 'Title',
               description: 'MyText',
               basic: false,
               map: @map
             )
           ])
  end

  it 'renders a list of status' do
    render
    cell_selector = 'tr>td'
    assert_select cell_selector, text: Regexp.new('Title'.to_s), count: 2
    assert_select cell_selector, text: Regexp.new('MyText'.to_s), count: 2
    assert_select cell_selector, text: Regexp.new('MyMap'.to_s), count: 2
  end
end
