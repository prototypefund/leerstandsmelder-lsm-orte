# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::PlacesController, type: :controller do
  # needed for json builder test, since json builder files are handled as views
  render_views

  describe "functionalities with logged in user with role 'admin'" do
    before do
      group = FactoryBot.create(:group)
      user = FactoryBot.create(:admin_user, group_id: group.id)
      sign_in user
      @map = FactoryBot.create(:map, group_id: group.id)
      @layer = FactoryBot.create(:layer, map_id: @map.id)
    end

    let(:place) do
      FactoryBot.create(:place, layer_id: @layer.id)
    end

    let(:valid_attributes) do
      FactoryBot.build(:place, layer_id: @layer.id).attributes
    end

    let(:invalid_attributes) do
      FactoryBot.attributes_for(:place, :invalid, layer_id: @layer.id)
    end

    let(:valid_session) { {} }

    describe 'GET #index' do
      it 'returns a success response' do
        place = Place.create! valid_attributes
        get :index, params: { layer_id: @layer.id, map_id: @map.id }, session: valid_session, format: :json
        expect(response).to have_http_status(200)
      end
    end
    describe 'GET #show' do
      it 'create a place, update and count all versions', versioning: true do
        c = FactoryBot.create(:place, layer_id: @layer.id, map_id: @map.id)
        c.update!(published: true)
        get :show, params: { id: c.to_param }, session: valid_session, format: :json
        c.reload
        expect(c.versions.length).to(eq(2))
      end
    end
  end
end
