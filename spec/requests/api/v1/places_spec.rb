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

    describe 'GET /new' do
      it 'renders a unauthroized response' do
        get "/api/v1/maps/#{@map.id}/layers/#{@layer.id}/places/new"
        expect(response.status).to eq(401)
      end
    end

    describe 'GET /edit' do
      it 'render a unauthorized response' do
        place = Place.create! valid_attributes
        get "/api/v1/maps/#{@map.id}/layers/#{@layer.id}/places/#{place.id}/edit"
        # response should have HTTP Status 401 unauthorized
        expect(response.status).to eq(401)
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
      it 'renders a successful response' do
        Place.create! valid_attributes
        get "/api/v1/maps/#{@map.id}/layers/#{@layer.id}/places"
        expect(response).to be_successful
      end
    end

    describe 'GET /show' do
      it 'renders a successful response (for a published place)' do
        p = FactoryBot.create(:place, user: @other_user, published: true)
        get "/api/v1/maps/#{@map.id}/layers/#{@layer.id}/places/#{p.id}"
        expect(response).to be_successful
      end

      it 'renders a non-successful response (for a un-published place)' do
        p = FactoryBot.create(:place, user: @other_user, published: false)
        get "/api/v1/maps/#{@map.id}/layers/#{@layer.id}/places/#{p.id}"
        expect(response.status).to eq(401)
      end
    end

    describe 'GET /new' do
      it 'renders a successful response' do
        get "/api/v1/maps/#{@map.id}/layers/#{@layer.id}/places/new"
        expect(response).to be_successful
      end
    end

    describe 'GET /edit' do
      it 'render an authorized response (edit view of my place)' do
        place = FactoryBot.create(:place, user: @user)
        get "/api/v1/maps/#{@map.id}/layers/#{@layer.id}/places/#{place.id}/edit"
        expect(response).to be_successful
      end

      it 'render a unauthorized response (edit view of any other place)' do
        place = FactoryBot.create(:place, user: @other_user)
        get "/api/v1/maps/#{@map.id}/layers/#{@layer.id}/places/#{place.id}/edit"
        # response should have HTTP Status 403 Forbidden
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
          p = Place.all.last
          expect(json['id']).to eq(p.id)
          # expect(json['places'].size).to eq(1)
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

  describe 'Moderator (for map) is logged in' do
    before do
      group = FactoryBot.create(:group)
      @user = FactoryBot.create(:user, group: group)
      @other_user = FactoryBot.create(:user)

      @map = create(:map, group: group, published: true)
      @layer = create(:layer, map: @map, published: true)
      @user.add_role :moderator, @map

      sign_in @user
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

    describe 'GET /edit' do
      it 'render an authorized response (edit view of moderated place)' do
        place = FactoryBot.create(:place, map: @map, layer: @layer, user: @other_user)
        get "/api/v1/maps/#{@map.id}/layers/#{@layer.id}/places/#{place.id}/edit"

        expect(response).to be_successful
      end

      it 'render a authorized response (edit view of any other place)' do
        place = FactoryBot.create(:place, map: @map, layer: @layer, user: @other_user)
        get "/api/v1/maps/#{@map.id}/layers/#{@layer.id}/places/#{place.id}/edit"
        expect(response).to be_successful
      end
    end

    describe 'PATCH /update' do
      context 'with valid parameters' do
        let(:new_attributes) do
          FactoryBot.attributes_for(:place, :changed)
        end

        it 'renders an successful response (update of forgein place as a moderator)' do
          place = FactoryBot.create(:place, title: 'housing', layer: @layer, map: @map, user: @other_user)
          patch "/api/v1/maps/#{@map.id}/layers/#{@layer.id}/places/#{place.id}", params: { place: new_attributes }
          place.reload
          expect(place.title).to eq('OtherTitle')
          expect(response).to be_successful
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

    describe 'GET /new' do
      it 'renders a successful response' do
        get "/api/v1/maps/#{@map.id}/layers/#{@layer.id}/places/new"
        expect(response).to be_successful
      end
    end

    describe 'GET /edit' do
      it 'render a success response' do
        place = Place.create! valid_attributes
        get "/api/v1/maps/#{@map.id}/layers/#{@layer.id}/places/#{place.id}/edit"
        expect(response.status).to eq(204)
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
