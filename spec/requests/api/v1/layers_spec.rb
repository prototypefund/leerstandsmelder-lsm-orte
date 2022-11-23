# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Layers', type: :request do
  describe 'No user logged in' do
    before do
      group = FactoryBot.create(:group)
      @map = create(:map, group: group, published: true)
    end

    describe 'GET /show' do
      it 'renders a successful response (for a published layer)' do
        @layer = create(:layer, map: @map, published: true)
        get "/api/v1/maps/#{@map.id}/layers/#{@layer.id}"
        expect(response).to be_successful
      end

      it 'renders a non-successful response (for a un-published layer)' do
        layer = create(:layer, map: @map, published: false)
        get "/api/v1/maps/#{@map.id}/layers/#{layer.id}"
        expect(response).not_to be_successful
      end
    end
  end

  describe 'User is logged in' do
    before do
      group = FactoryBot.create(:group)
      user = FactoryBot.create(:user, group: group)
      sign_in user
      @map = create(:map, published: true)
    end

    describe 'GET /show' do
      it 'renders a successful response (for a published layer)' do
        @layer = create(:layer, map: @map, published: true)
        get "/api/v1/maps/#{@map.id}/layers/#{@layer.id}"
        expect(response).to be_successful
      end

      it 'renders a non-successful response (for a un-published layer)' do
        layer = create(:layer, map: @map, published: false)
        get "/api/v1/maps/#{@map.id}/layers/#{layer.id}"
        expect(response).not_to be_successful
      end
    end
  end

  describe 'ADMINUSER is logged in' do
    before do
      group = FactoryBot.create(:group)
      user = FactoryBot.create(:admin_user, group: group)
      sign_in user
      @map = create(:map, group: group, published: true)
      @layer = create(:layer, map: @map, published: true)
    end

    describe 'GET /show' do
      it 'return the layer' do
        get "/api/v1/maps/#{@map.id}/layers/#{@layer.id}"
        expect(json.size).to eq(1)
        expect(json['layer']['id']).to eq(@layer.id)
      end

      it 'returns status code 200' do
        get "/api/v1/maps/#{@map.id}/layers/#{@layer.id}"
        expect(response).to have_http_status(:success)
      end
    end
  end
end
