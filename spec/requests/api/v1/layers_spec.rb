# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Layers', type: :request do
  describe 'GET /show with logged in user' do
    before do
      group = FactoryBot.create(:group)
      user = FactoryBot.create(:user, group: group)
      sign_in user

      @map = create(:map, published: true)
      @layer = create(:layer, published: true, map: @map)

      get "/api/v1/maps/#{@map.id}/layers/#{@layer.id}"
    end

    it 'return the layer' do
      expect(json.size).to eq(1)
      expect(json['layer']['id']).to eq(@layer.id)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(:success)
    end
  end
end
