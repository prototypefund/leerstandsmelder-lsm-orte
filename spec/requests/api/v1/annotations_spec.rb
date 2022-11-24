# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Annotations', type: :request do
  let(:valid_attributes) do
    FactoryBot.build(:annotation, place: @place).attributes
  end

  describe 'No user logged in' do
    before do
      group = create(:group)
      @map = create(:map, group: group, published: true)
      @layer = create(:layer, map: @map, published: true)
      @place = create(:place, layer: @layer, published: true)
    end

    describe 'GET /index' do
      it 'renders a successful response (for all annotations of a published place)' do
        pending 'this should be possible to view for everybody'
        @annotation = create(:annotation, place: @place, published: true)
        get "/api/v1/places/#{@place.id}/annotations"
        expect(response).to be_successful
      end
    end

    describe 'GET /show' do
      it 'renders a successful response (for an annotation of a published place)' do
        @annotation = create(:annotation, place: @place, published: true)
        get "/api/v1/places/#{@place.id}/annotations/#{@annotation.id}"
        expect(response).to be_successful
      end
    end

    describe 'GET /new' do
      it 'renders a unauthroized response' do
        get "/api/v1/places/#{@place.id}/annotations/new"
        expect(response).not_to be_successful
      end
    end

    describe 'GET /edit' do
      it 'render a unauthorized response' do
        annotation = Annotation.create! valid_attributes
        get "/api/v1/places/#{@place.id}/annotations/#{annotation.id}/edit"
        expect(response).not_to be_successful
      end
    end

    describe 'POST /create' do
      it 'renders a forbidden response' do
        post "/api/v1/places/#{@place.id}/annotations/", params: { annotation: valid_attributes }
        expect(response).not_to be_successful
      end
    end

    describe 'DELETE /destroy' do
      it 'is not allowed to destroy the requested place' do
        annotation = Annotation.create! valid_attributes
        expect do
          delete "/api/v1/places/#{@place.id}/annotations/#{annotation.id}"
        end.to change(Annotation, :count).by(0)
      end
    end
  end

  describe 'User is logged in' do
    before do
      group = FactoryBot.create(:group)
      @user = FactoryBot.create(:user, group: group)
      sign_in @user
      @map = create(:map, published: true)
      @layer = create(:layer, map: @map, published: true)
      @place = create(:place, layer: @layer, published: true)
    end

    describe 'GET /show' do
      it 'renders a successful response (for an annotation of a published place)' do
        @annotation = create(:annotation, place: @place, user: @user, published: true)
        get "/api/v1/places/#{@place.id}/annotations/#{@annotation.id}"
        expect(response).to be_successful
      end
    end

    describe 'GET /new' do
      it 'renders an authorized response' do
        get "/api/v1/places/#{@place.id}/annotations/new"
        expect(response).to be_successful
      end
    end

    describe 'GET /edit' do
      it 'render an un-authorized response' do
        annotation = Annotation.create! valid_attributes
        get "/api/v1/places/#{@place.id}/annotations/#{annotation.id}/edit"
        expect(response).not_to be_successful
      end
    end

    describe 'POST /create' do
      it 'renders an authorized response' do
        post "/api/v1/places/#{@place.id}/annotations/", params: { annotation: valid_attributes }
        expect(response).to be_successful
      end
    end

    describe 'DELETE /destroy' do
      it 'is not allowed to destroy the requested place' do
        annotation = Annotation.create! valid_attributes
        expect do
          delete "/api/v1/places/#{@place.id}/annotations/#{annotation.id}"
        end.to change(Annotation, :count).by(0)
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
      @place = create(:place, layer: @layer, published: true)
    end

    describe 'GET /show' do
      it 'renders a successful response (for an annotation of a published place)' do
        @annotation = create(:annotation, place: @place, user: @user, published: true)
        get "/api/v1/places/#{@place.id}/annotations/#{@annotation.id}"
        expect(response).to be_successful
      end
    end

    describe 'GET /show' do
      it 'renders a successful response (for an annotation of a published place)' do
        @annotation = create(:annotation, place: @place, user: @user, published: true)
        get "/api/v1/places/#{@place.id}/annotations/#{@annotation.id}"
        expect(response).to be_successful
      end
    end

    describe 'GET /new' do
      it 'renders an authorized response' do
        get "/api/v1/places/#{@place.id}/annotations/new"
        expect(response).to be_successful
      end
    end

    describe 'GET /edit' do
      it 'render an authorized response' do
        annotation = Annotation.create! valid_attributes
        get "/api/v1/places/#{@place.id}/annotations/#{annotation.id}/edit"
        expect(response).to be_successful
      end
    end

    describe 'POST /create' do
      it 'renders an authorized response' do
        post "/api/v1/places/#{@place.id}/annotations/", params: { annotation: valid_attributes }
        expect(response).to be_successful
      end
    end

    describe 'DELETE /destroy' do
      it 'is allowed to destroy the requested place' do
        annotation = Annotation.create! valid_attributes
        expect do
          delete "/api/v1/places/#{@place.id}/annotations/#{annotation.id}"
        end.to change(Annotation, :count).by(-1)
      end
    end
  end
end
