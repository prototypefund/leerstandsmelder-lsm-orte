# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'status/edit', type: :view do
  let(:status) do
    Status.create!(
      title: 'MyString',
      description: 'MyText',
      basic: false,
      map: ''
    )
  end

  before(:each) do
    assign(:status, status)
  end

  it 'renders the edit status form' do
    render

    assert_select 'form[action=?][method=?]', status_path(status), 'post' do
      assert_select 'input[name=?]', 'status[title]'

      assert_select 'textarea[name=?]', 'status[description]'

      assert_select 'input[name=?]', 'status[basic]'

      assert_select 'input[name=?]', 'status[map]'
    end
  end
end
