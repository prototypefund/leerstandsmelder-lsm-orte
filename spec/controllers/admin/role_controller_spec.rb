# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::RolesController, type: :controller do
  describe 'for guests' do
    describe 'GET #index' do
      it 'no access' do
        get :index, params: {}
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "functionalities with logged in user with role 'user'" do
    before(:all) do
      User.destroy_all
      @group = FactoryBot.create(:group)
      @user = FactoryBot.create(:user, group_id: @group.id)
    end

    before(:each) do
      sign_in(@user)
    end

    describe 'GET #index' do
      xit 'Should redirect to startpage with a friendly message' do
        pending('We need a role-based auth model')
      end
    end
  end

  describe "functionalities with logged in user with role 'admin'" do
    before(:all) do
      User.destroy_all
      @admin_group = FactoryBot.create(:group)
      @other_group = FactoryBot.create(:group)

      @admin_user = FactoryBot.create(:admin_user, group_id: @admin_group.id)
      @other_user = FactoryBot.create(:admin_user, group_id: @other_group.id)

      @admin_user.add_role :admin
    end

    before(:each) do
      sign_in(@admin_user)
    end

    # This should return the minimal set of attributes required to create a valid
    # User. As you add validations to Admin::User, be sure to
    # adjust the attributes here as well.
    let(:valid_attributes) do
      { email: 'admin@domain.com',
        password: '1234567890ß',
        group: @admin_group }
    end

    let(:invalid_attributes) do
      { name: '' }
    end

    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # Admin::UsersController. Be sure to keep this updated too.
    let(:valid_session) { {} }

    describe 'GET #index' do
      it 'assigns all roles as @admin_roles' do
        get :index, params: {}, session: valid_session
        expect(assigns(:admin_roles).size).to eq(2)
        expect(response).to render_template('index')
      end
    end
  end
end
