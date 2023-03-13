# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::MapsController, type: :controller do
  render_views

  describe 'functionalities with not logged in user ' do
    before do
      @group = FactoryBot.create(:group)
    end

    let(:map) do
      FactoryBot.create(:map, group_id: @group.id)
    end

    let(:valid_attributes) do
      FactoryBot.build(:map, group_id: @group.id, published: true).attributes
    end

    let(:invalid_attributes) do
      FactoryBot.build(:map, group_id: @group.id, published: false).attributes
    end

    let(:valid_session) { {} }

    describe 'GET #index' do
      it 'returns a success response for published maps' do
        map = Map.create! valid_attributes
        get :index, params: { format: 'json' }, session: valid_session
        expect(response).to have_http_status(200)
      end

      it 'returns a success response for unpublished resources' do
        map = Map.create! invalid_attributes
        get :index, params: { format: 'json' }, session: valid_session
        expect(response).to have_http_status(200)
      end
      it 'returns json with a valid scheme' do
        map = Map.create! valid_attributes
        layer = FactoryBot.create(:layer, map_id: map.id, published: true)
        place = FactoryBot.create(:place, layer_id: layer.id, published: true)
        get :index, params: { id: map.friendly_id, format: 'json' }, session: valid_session
        puts response
        expect(response).to match_response_schema('v1/maps/index', 'json')
      end
    end

    describe 'GET #show' do
      it 'returns a success response for a published map' do
        map = Map.create! valid_attributes
        get :show, params: { id: map.friendly_id, format: 'json' }, session: valid_session
        expect(response).to have_http_status(200)
      end

      it 'returns json for a published map' do
        map = Map.create! valid_attributes
        get :show, params: { id: map.friendly_id, format: 'json' }, session: valid_session
        expect(response).to have_http_status(200)
        expect(response.status).to eq 200
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end

      it 'returns json with a valid scheme' do
        map = FactoryBot.create(:map, published: true)
        layer = FactoryBot.create(:layer, map_id: map.id, published: true)
        place = FactoryBot.create(:place, layer_id: layer.id, published: true, featured: false)
        get :show, params: { id: map.friendly_id, format: 'json', locale: 'de' }, session: valid_session
        expect(response).to match_response_schema('v1/maps/show', 'json')
      end

      it 'returns an 403 + error response for unpublished resources' do
        map = FactoryBot.create(:map, published: false)
        get :show, params: { id: map.friendly_id, format: 'json' }, session: valid_session
        expect(response).to have_http_status(404)
        expect(JSON.parse(response.body)['error']).to match(/record not found/)
      end
    end
  end
  describe "functionalities with logged in user with role 'admin'" do
    before do
      @group = FactoryBot.create(:group)
      user = FactoryBot.create(:admin_user, group_id: @group.id)
      sign_in user
    end

    describe 'GET #show' do
      let(:valid_session) { {} }
      it 'returns json with an valid schema for  unpublished resources' do
        map = FactoryBot.create(:map, published: false)
        get :show, params: { id: map.friendly_id, format: 'json' }, session: valid_session
        expect(response).to have_http_status(200)
        expect(response).to match_response_schema('v1/maps/show', 'json')
      end
    end
  end
end
