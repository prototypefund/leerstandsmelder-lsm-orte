# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'status/index', type: :view do
  before(:each) do
    assign(:status, [
             Status.create!(
               title: 'Title',
               description: 'MyText',
               basic: false,
               map: ''
             ),
             Status.create!(
               title: 'Title',
               description: 'MyText',
               basic: false,
               map: ''
             )
           ])
  end

  it 'renders a list of status' do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new('Title'.to_s), count: 2
    assert_select cell_selector, text: Regexp.new('MyText'.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(''.to_s), count: 2
  end
end
