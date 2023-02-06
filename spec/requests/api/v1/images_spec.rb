# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Images', type: :request do
  let(:valid_attributes) do
    FactoryBot.build(:image, place: @place).attributes
  end

  describe 'No user logged in' do
    before do
      group = create(:group)
      @map = create(:map, group: group, published: true)
      @layer = create(:layer, map: @map, published: true)
      @place = create(:place, layer: @layer, published: true)
    end

    describe 'GET /index' do
      it 'renders a successful response (for all images of a published place)' do
        @image = create(:image, place: @place)
        get "/api/v1/places/#{@place.id}/images"
        expect(response).to be_successful
      end
    end

    describe 'GET /show' do
      it 'renders a successful response (for an image of a published place)' do
        @image = create(:image, place: @place)
        get "/api/v1/places/#{@place.id}/images/#{@image.id}"
        expect(response).to be_successful
      end
    end

    describe 'POST /create' do
      it 'renders a forbidden response' do
        post "/api/v1/places/#{@place.id}/images/", params: { image: valid_attributes }
        expect(response).not_to be_successful
      end
    end

    describe 'DELETE /destroy' do
      it 'is not allowed to destroy the requested place' do
        image = Image.create! valid_attributes
        expect do
          delete "/api/v1/places/#{@place.id}/images/#{image.id}"
        end.to change(Image, :count).by(0)
      end
    end
  end

  describe 'User is logged in' do
    before do
      group = FactoryBot.create(:group)
      user = FactoryBot.create(:user, group: group)
      sign_in user
      @map = create(:map, published: true)
      @layer = create(:layer, map: @map, published: true)
      @place = create(:place, layer: @layer, published: true)
    end

    describe 'GET /show' do
      it 'renders a successful response (for an image of a published place)' do
        @image = create(:image, place: @place)
        get "/api/v1/places/#{@place.id}/images/#{@image.id}"
        expect(response).to be_successful
      end
    end

    # TODO: CRUD actions
  end

  describe 'ADMINUSER is logged in' do
    before do
      group = FactoryBot.create(:group)
      user = FactoryBot.create(:admin_user, group: group)
      sign_in user
      @map = create(:map, group: group, published: true)
      @layer = create(:layer, map: @map, published: true)
      @place = create(:place, layer: @layer, published: true)
    end

    describe 'GET /show' do
      it 'renders a successful response (for an image of a published place)' do
        @image = create(:image, place: @place)
        get "/api/v1/places/#{@place.id}/images/#{@image.id}"
        expect(response).to be_successful
      end
    end

    # TODO: CRUD actions
  end
end
