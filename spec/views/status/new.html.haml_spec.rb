# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'status/new', type: :view do
  before(:each) do
    @map = FactoryBot.create(:map)
    assign(:status, Status.new(
                      title: 'MyString',
                      description: 'MyText',
                      basic: false,
                      map: @map
                    ))
  end

  it 'renders new status form' do
    render

    assert_select 'form[action=?][method=?]', '/status', 'post' do
      assert_select 'input[name=?]', 'status[title]'

      assert_select 'textarea[name=?]', 'status[description]'

      assert_select 'input[name=?]', 'status[basic]'
    end
  end
end
