# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:valid_attributes) do
    FactoryBot.build(:user, group: @group).attributes
  end

  describe 'No user logged in' do
    before do
      @group = FactoryBot.create(:group)
      @user = FactoryBot.create(:user, group: @group)
      @map = create(:map, group: @group, published: true)
      @layer = create(:layer, map: @map, published: true)
    end

    describe 'GET /index' do
      it 'renders an un-successful response' do
        get '/api/v1/users/users'
        expect(response).not_to be_successful
      end
    end

    describe 'GET /show' do
      it 'renders an un-successful response' do
        get "/api/v1/users/#{@user.id}"
        expect(response).not_to be_successful
      end
    end

    describe 'GET /new' do
      it 'renders a successful response' do
        get '/api/v1/users/new'
        expect(response).to be_successful
      end
    end

    describe 'GET /edit' do
      it 'renders an un-successful response' do
        get "/api/v1/users/#{@user.id}/edit"
        expect(response).not_to be_successful
      end
    end

    describe 'POST /create' do
      it 'renders a successful response' do
        pending 'generated user_url fails'
        expect do
          post '/api/v1/users', params: { user: valid_attributes }
        end.to change(User, :count).by(1)
        expect(response).to be_successful
      end
    end

    describe 'PATCH /update' do
      it 'renders an un-successful response' do
        patch "/api/v1/users/#{@user.id}"
        expect(response).not_to be_successful
      end
    end

    describe 'DELETE /destroy' do
      it 'renders an un-successful response' do
        expect do
          delete "/api/v1/users/#{@user.id}"
        end.to change(User, :count).by(0)
      end
    end
  end

  describe 'User is logged in' do
    before do
      @group = FactoryBot.create(:group)
      @user = FactoryBot.create(:user, group: @group)
      sign_in @user
      @map = create(:map, group: @group, published: true)
      @layer = create(:layer, map: @map, published: true)
    end

    describe 'GET /index' do
      it 'renders an un-successful response' do
        get '/api/v1/users/users'
        expect(response).not_to be_successful
      end
    end

    describe 'GET /show' do
      it 'renders an un-successful response' do
        get "/api/v1/users/#{@user.id}"
        expect(response).not_to be_successful
      end
    end

    describe 'GET /new' do
      it 'renders a successful response' do
        get '/api/v1/users/new'
        expect(response).to be_successful
      end
    end

    describe 'GET /edit' do
      it 'renders an un-successful response' do
        get "/api/v1/users/#{@user.id}/edit"
        expect(response).not_to be_successful
      end
    end

    describe 'POST /create' do
      xit 'renders a successful response' do
        pending 'generated user_url fails'
        expect do
          post '/api/v1/users', params: { user: valid_attributes }
        end.to change(User, :count).by(1)
        expect(response).to be_successful
      end
    end

    describe 'PATCH /update' do
      it 'renders an un-successful response' do
        patch "/api/v1/users/#{@user.id}"
        expect(response).not_to be_successful
      end
    end

    describe 'DELETE /destroy' do
      it 'renders an un-successful response' do
        expect do
          delete "/api/v1/users/#{@user.id}"
        end.to change(User, :count).by(0)
      end
    end
  end

  describe 'ADMINUSER is logged in' do
    before do
      @group = FactoryBot.create(:group)
      @user = FactoryBot.create(:admin_user, group: @group)
      @other_user = FactoryBot.create(:admin_user, group: @group)
      sign_in @user
      @map = create(:map, group: @group, published: true)
      @layer = create(:layer, map: @map, published: true)
    end

    describe 'GET /index' do
      it 'renders an successful response' do
        get '/api/v1/users'
        expect(response).to be_successful
      end
    end

    describe 'GET /show' do
      it 'renders a successful response' do
        pending 'TODO: this has a redirect_to'
        get "/api/v1/users/#{@other_user.id}"
        expect(response).to be_successful
      end
    end

    describe 'GET /new' do
      it 'renders a successful response' do
        get '/api/v1/users/new'
        expect(response).to be_successful
      end
    end

    describe 'GET /edit' do
      it 'renders a successful response' do
        get "/api/v1/users/#{@other_user.id}/edit"
        expect(response).to be_successful
      end
    end

    describe 'POST /create' do
      it 'renders a successful response' do
        pending 'generated user_url fails'
        expect do
          post '/api/v1/users', params: { user: valid_attributes }
        end.to change(User, :count).by(1)
        expect(response).to be_successful
      end
    end

    describe 'PATCH /update' do
      let(:new_attributes) do
        FactoryBot.attributes_for(:user, :changed)
      end

      it 'renders a successful response' do
        patch "/api/v1/users/#{@other_user.id}", params: { user: new_attributes }
        expect(response).to be_successful
      end
    end

    describe 'DELETE /destroy' do
      it 'renders a successful response' do
        expect do
          delete "/api/v1/users/#{@other_user.id}"
        end.to change(User, :count).by(-1)
      end
    end
  end
end
