# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Maps', type: :request do
  describe 'GET /index' do
    before do
      FactoryBot.create_list(:map, 10, published: true)
      create(:map, published: false)
      get '/api/v1/maps'
    end

    it 'returns all maps' do
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /index with logged in user' do
    before do
      FactoryBot.create_list(:map, 10, published: true)
      create(:map, published: false)
      group = FactoryBot.create(:group)
      user = FactoryBot.create(:user, group: group)
      sign_in user
      get '/api/v1/maps'
    end

    it 'returns all published maps' do
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /index with logged in admin user' do
    before do
      Map.destroy_all
      FactoryBot.create_list(:map, 10, published: true)
      create(:map, published: false)
      group = FactoryBot.create(:group)
      user = FactoryBot.create(:admin_user, group: group)
      sign_in user
      get '/api/v1/maps'
    end

    it 'returns all maps (published & unpublished)' do
      expect(json.size).to eq(11)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /show' do
    before do
      @map = create(:map, published: true)
      @layer = create(:layer, published: true, map: @map)
      place1 = create(:place, published: true, layer: @layer)
      place2 = create(:place, published: false, layer: @layer)
      get "/api/v1/maps/#{@map.id}"
    end

    it 'return the map  and all places' do
      expect(json.size).to eq(1)
      expect(json['map']['places'].size).to eq(1)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(:success)
    end
  end
  describe 'GET /show with parameter ?show_by_layer=true' do
    before do
      FactoryBot.create_list(:map, 10, published: true)
      @map = create(:map, published: true)
      @layer = create(:layer, map: @map, published: true)
      get "/api/v1/maps/#{@map.id}?show_by_layer=true"
    end

    it 'returns all maps and layers' do
      expect(json['map']['layer'].size).to eq(1)
    end
  end
  describe 'GET /show with logged in admin user' do
    before do
      @map = create(:map, published: true)
      @layer = create(:layer, published: true, map: @map)
      place1 = create(:place, published: true, layer: @layer)
      place2 = create(:place, published: false, layer: @layer)
      group = FactoryBot.create(:group)
      user = FactoryBot.create(:admin_user, group: group)
      sign_in user
      get "/api/v1/maps/#{@map.id}"
    end

    it 'return the map  and all places (published & unpublished)' do
      expect(json.size).to eq(1)

      expect(json['map']['places'].size).to eq(2)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(:success)
    end
  end
end
