# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'status/new', type: :view do
  before(:each) do
    assign(:status, Status.new(
                      title: 'MyString',
                      description: 'MyText',
                      basic: false,
                      map: ''
                    ))
  end

  it 'renders new status form' do
    render

    assert_select 'form[action=?][method=?]', status_path, 'post' do
      assert_select 'input[name=?]', 'status[title]'

      assert_select 'textarea[name=?]', 'status[description]'

      assert_select 'input[name=?]', 'status[basic]'

      assert_select 'input[name=?]', 'status[map]'
    end
  end
end
