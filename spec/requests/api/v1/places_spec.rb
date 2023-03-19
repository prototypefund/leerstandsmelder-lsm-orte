# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Places', type: :request do
  let(:valid_attributes) do
    FactoryBot.build(:place, layer: @layer, published: true).attributes
  end

  let(:invalid_attributes) do
    build_attributes(:place, :invalid, layer: @layer)
  end

  describe 'No user logged in' do
    before do
      group = FactoryBot.create(:group)
      @map = create(:map, group: group, published: true)
      @layer = create(:layer, map: @map, published: true)
    end

    describe 'GET /index' do
      it 'renders a successful response' do
        Place.create! valid_attributes
        get "/api/v1/maps/#{@map.id}/layers/#{@layer.id}/places"
        expect(response).to be_successful
      end
    end

    describe 'GET /show' do
      it 'renders a successful response (for a published place)' do
        p = Place.create! valid_attributes
        get "/api/v1/maps/#{@map.id}/layers/#{@layer.id}/places/#{p.id}"
        expect(response).to be_successful
      end

      it 'renders a non-successful response (for a un-published place)' do
        p = FactoryBot.create(:place, layer: @layer, published: false)
        get "/api/v1/maps/#{@map.id}/layers/#{@layer.id}/places/#{p.id}"
        expect(response).not_to be_successful
      end
    end

    describe 'POST /create' do
      it 'renders a forbidden response' do
        post "/api/v1/maps/#{@map.id}/layers/#{@layer.id}/places", params: { place: valid_attributes }
        expect(response.status).to eq(401)
      end
    end

    describe 'DELETE /destroy' do
      it 'is not allowed to destroy the requested place' do
        place = Place.create! valid_attributes
        expect do
          delete "/api/v1/maps/#{@map.id}/layers/#{@layer.id}/places/#{place.id}"
        end.to change(Place, :count).by(0)
      end
    end
  end

  describe 'User is logged in' do
    before do
      group = FactoryBot.create(:group)
      @user = FactoryBot.create(:user, group: group)
      @other_user = FactoryBot.create(:user)
      sign_in @user
      @map = create(:map, group: group, published: true)
      @layer = create(:layer, map: @map, published: true)
    end

    describe 'GET /index' do
      it 'renders a successful response and returns only published places' do
        p = FactoryBot.create(:place, published: true, map: @map, layer: @layer, user: @user)
        p2 = FactoryBot.create(:place, published: false, map: @map, layer: @layer, user: @other_user)
        map_alt = create(:map, published: true)
        layer_alt = create(:layer, map: map_alt, published: true)
        p3 = FactoryBot.create(:place, published: false, map: map_alt, layer: layer_alt, user: @user)
        get "/api/v1/maps/#{@map.id}/layers/#{@layer.id}/places"
        expect(response).to be_successful
        expect(json.size).to eq(1)
      end
    end

    describe 'GET /show' do
      it 'renders a successful response (for a published place)' do
        p = FactoryBot.create(:place, user: @other_user, published: true)
        get "/api/v1/maps/#{@map.id}/layers/#{@layer.id}/places/#{p.id}"
        expect(response).to be_successful
      end
      it 'renders a successful response (for a published place) (short route)' do
        p = FactoryBot.create(:place, user: @other_user, published: true)
        get "/api/v1/places/#{p.id}"
        expect(response).to be_successful
      end

      it 'renders a non-successful response (for a un-published place)' do
        p = FactoryBot.create(:place, user: @other_user, published: false)
        get "/api/v1/maps/#{@map.id}/layers/#{@layer.id}/places/#{p.id}"
        expect(response.status).to eq(401)
      end
    end

    describe 'POST /create' do
      context 'with valid parameters' do
        it 'creates a new place and renders a successful json response' do
          expect do
            post "/api/v1/maps/#{@map.id}/layers/#{@layer.id}/places", params: { place: valid_attributes }
          end.to change(Place, :count).by(1)
          expect(response).to be_successful
          expect(response).to have_http_status(201)
          p = Place.all.last
          expect(json['id']).to eq(p.id)
          expect(response).to match_response_schema('v1/places/create', 'json')
        end
      end
      let(:different_location_attributes) do
        FactoryBot.build(:place, map: @map, layer: @layer, published: true, lat: 0.2, lon: 10.2).attributes
      end
      context 'with valid parameters but different region' do
        it 'creates a new place and renders a message explaingin not region found' do
          group_off = FactoryBot.create(:group)
          map_off = create(:map, group: group_off, published: true, mapcenter_lat: 3.5, mapcenter_lon: 3.5)
          layer_off = create(:layer, map: map_off, published: true)
          expect do
            post "/api/v1/maps/#{map_off.id}/layers/#{layer_off.id}/places", params: { place: different_location_attributes }
          end.to change(Place, :count).by(1)
          expect(response).to be_successful
          expect(response).to have_http_status(201)
          p = Place.all.last
          puts json.inspect
          expect(json['id']).to eq(p.id)
          expect(json['layer_id']).not_to eq(layer_off.id)
          expect(response).to match_response_schema('v1/places/create_missing_region', 'json')
        end
      end

      context 'with invalid parameters' do
        it 'does not create a new Place' do
          expect do
            post "/api/v1/maps/#{@map.id}/layers/#{@layer.id}/places", params: { place: invalid_attributes }
          end.to change(Place, :count).by(0)
        end

        it 'renders a un-successful response' do
          post "/api/v1/maps/#{@map.id}/layers/#{@layer.id}/places", params: { place: invalid_attributes }
          expect(response).not_to be_successful
        end
      end
    end

    describe 'PATCH /update' do
      context 'with valid parameters' do
        let(:new_attributes) do
          FactoryBot.attributes_for(:place, :changed)
        end

        it 'renders a successful response (update of my place)' do
          place = FactoryBot.create(:place, user: @user)
          patch "/api/v1/maps/#{@map.id}/layers/#{@layer.id}/places/#{place.id}", params: { place: new_attributes }
          place.reload
          expect(response).to be_successful
          expect(place.title).to eq('OtherTitle')
        end

        it 'renders an unsuccessful response (update of forgein place)' do
          place = FactoryBot.create(:place, user: @other_user)
          patch "/api/v1/maps/#{@map.id}/layers/#{@layer.id}/places/#{place.id}", params: { place: new_attributes }
          place.reload
          expect(place.title).to eq('MyTitle')
          expect(response.status).to eq(401)
        end

        it 'renders a non-successful response (update of any other place)' do
          place = Place.create! valid_attributes
          patch "/api/v1/maps/#{@map.id}/layers/#{@layer.id}/places/#{place.id}", params: { place: new_attributes }
          place.reload
          expect(place.title).to eq('MyTitle')
          expect(response).not_to be_successful
        end
      end
    end

    describe 'DELETE /destroy' do
      it 'is not allowed to destroy the requested place' do
        place = Place.create! valid_attributes
        expect do
          delete "/api/v1/maps/#{@map.id}/layers/#{@layer.id}/places/#{place.id}"
        end.to change(Place, :count).by(0)
      end
    end
  end

  describe 'Moderator (for a map) is logged in' do
    before do
      group = FactoryBot.create(:group)
      @user = FactoryBot.create(:user, group: group)
      @other_user = FactoryBot.create(:user)

      @map = create(:map, group: group, published: true)
      @layer = create(:layer, map: @map, published: true)
      @user.add_role :moderator, @map

      @other_map = create(:map, group: group, published: true)
      @other_layer = create(:layer, map: @other_map, published: true)
      @user.add_role :user, @other_map

      sign_in @user
    end

    describe 'GET /index' do
      it 'renders a successful response and returns all places on this map' do
        p = FactoryBot.create(:place, published: true, map: @map, layer: @layer, user: @other_user)
        p2 = FactoryBot.create(:place, published: false, map: @map, layer: @layer, user: @other_user)
        p3 = FactoryBot.create(:place, published: false, map: @other_map, layer: @other_layer, user: @user)
        get "/api/v1/maps/#{@map.id}/layers/#{@layer.id}/places"
        expect(response).to be_successful
        expect(json.size).to eq(2)
      end
    end

    describe 'GET /show' do
      it 'renders a successful response (for a published place)' do
        p = FactoryBot.create(:place, published: true, map: @map, layer: @layer, user: @other_user)
        get "/api/v1/maps/#{@map.id}/layers/#{@layer.id}/places/#{p.id}"
        expect(response).to be_successful
      end

      it 'renders a successful response (for a un-published place)' do
        p = FactoryBot.create(:place, published: false, map: @map, layer: @layer, user: @other_user)
        get "/api/v1/maps/#{@map.id}/layers/#{@layer.id}/places/#{p.id}"
        expect(response).to be_successful
      end
    end

    describe 'PATCH /update' do
      context 'with valid parameters' do
        let(:new_attributes) do
          FactoryBot.attributes_for(:place, :changed)
        end

        it 'renders a successful response (update of foreign place as a moderator)' do
          place = FactoryBot.create(:place, title: 'housing', layer: @layer, map: @map, user: @other_user)
          patch "/api/v1/maps/#{@map.id}/layers/#{@layer.id}/places/#{place.id}", params: { place: new_attributes }
          place.reload
          expect(place.title).to eq('OtherTitle')
          expect(response).to be_successful
        end

        it 'renders a successful response (update of my place)' do
          place = FactoryBot.create(:place, title: 'housing', layer: @other_layer, map: @other_map, user: @user)
          patch "/api/v1/maps/#{@other_map.id}/layers/#{@other_layer.id}/places/#{place.id}", params: { place: new_attributes }
          place.reload
          expect(place.title).to eq('OtherTitle')
          expect(response).to be_successful
        end

        it 'renders an unsuccessful response (update of any place in any other map)' do
          place = FactoryBot.create(:place, title: 'housing', layer: @other_layer, map: @other_map, user: @other_user)
          patch "/api/v1/maps/#{@other_map.id}/layers/#{@other_layer.id}/places/#{place.id}", params: { place: new_attributes }
          place.reload
          expect(place.title).to eq('housing')
          expect(response).not_to be_successful
        end
      end
    end

    describe 'DELETE /destroy' do
      it 'is allowed to destroy the requested place' do
        place = FactoryBot.create(:place, title: 'housing', layer: @layer, map: @map, user: @other_user)
        expect do
          delete "/api/v1/maps/#{@map.id}/layers/#{@layer.id}/places/#{place.id}"
        end.to change(Place, :count).by(-1)
      end

      it 'is not allowed to destroy the requested place (in any other map)' do
        place = FactoryBot.create(:place, title: 'housing', layer: @other_layer, map: @other_map, user: @other_user)
        expect do
          delete "/api/v1/maps/#{@other_map.id}/layers/#{@other_layer.id}/places/#{place.id}"
        end.to change(Place, :count).by(0)
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
    describe 'GET /index' do
      it 'renders a successful response' do
        Place.create! valid_attributes
        get "/api/v1/maps/#{@map.id}/layers/#{@layer.id}/places"
        expect(response).to be_successful
      end
    end

    describe 'GET /show' do
      before do
        @p = Place.create! valid_attributes
        get "/api/v1/places/#{@p.id}"
      end

      it 'returns a place' do
        expect(json['id']).to eq(@p.id)
      end
    end

    describe 'GET /show with parameter ?versions=true' do
      before do
        @p = Place.create! valid_attributes
        @p.featured = true
        @p.save!
        get "/api/v1/places/#{@p.id}?versions=true"
      end

      it 'returns all maps and layers' do
        expect(json['versions'].size).to eq(2)
      end
    end

    describe 'POST /create' do
      context 'with valid parameters' do
        it 'creates a new place and renders a successful json response' do
          expect do
            post "/api/v1/maps/#{@map.id}/layers/#{@layer.id}/places", params: { place: valid_attributes }
          end.to change(Place, :count).by(1)
          expect(response).to be_successful
          p = Place.all.last
          expect(json['id']).to eq(p.id)
        end
      end

      context 'with invalid parameters' do
        it 'does not create a new Place' do
          expect do
            post "/api/v1/maps/#{@map.id}/layers/#{@layer.id}/places", params: { place: invalid_attributes }
          end.to change(Place, :count).by(0)
        end

        it 'renders a un-successful response' do
          post "/api/v1/maps/#{@map.id}/layers/#{@layer.id}/places", params: { place: invalid_attributes }
          expect(response).not_to be_successful
        end
      end
    end

    describe 'PATCH /update' do
      context 'with valid parameters' do
        let(:new_attributes) do
          FactoryBot.attributes_for(:place, :changed)
        end

        it 'updates the requested place' do
          place = Place.create! valid_attributes
          patch "/api/v1/maps/#{@map.id}/layers/#{@layer.id}/places/#{place.id}", params: { place: new_attributes }
          place.reload
          expect(place.title).to eq('OtherTitle')
        end
      end
    end

    describe 'DELETE /destroy' do
      it 'destroys the requested place' do
        place = Place.create! valid_attributes
        expect do
          delete "/api/v1/maps/#{@map.id}/layers/#{@layer.id}/places/#{place.id}"
        end.to change(Place, :count).by(-1)
      end
    end
  end
end
