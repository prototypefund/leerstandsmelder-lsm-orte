# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'news/edit', type: :view do
  let(:news) do
    FactoryBot.create(:news, title: 'TitleNews')
  end

  before(:each) do
    assign(:news, news)
  end

  it 'renders the edit news form' do
    render

    assert_select 'form[action=?][method=?]', news_path(news), 'post' do
    end
  end
end
