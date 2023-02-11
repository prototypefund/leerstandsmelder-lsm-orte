# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'news/index', type: :view do
  before(:each) do
    assign(:news, [
             News.create!,
             News.create!
           ])
  end

  it 'renders a list of news' do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
  end
end
