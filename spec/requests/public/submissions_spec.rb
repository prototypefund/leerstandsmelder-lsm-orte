# frozen_string_literal: true

require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe '/public/submissions', type: :request do
  before do
    @map = FactoryBot.create(:map)
    @layer = FactoryBot.create(:layer, map: @map, public_submission: true)
    @submission = FactoryBot.create(:submission)
  end
  # Public::Submission. As you add validations to Public::Submission, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    FactoryBot.attributes_for(:submission)
  end

  let(:invalid_attributes) do
    FactoryBot.attributes_for(:submission, rights: false)
  end

  describe 'GET /en/1/submissions/new' do
    context 'with public submission disabled' do
      it 'renders a redirect' do
        layer = FactoryBot.create(:layer, map: @map, public_submission: false)
        get new_submission_path(layer_id: layer.id, locale: 'en')
        expect(response).to redirect_to(submissions_path)
      end
    end
    context 'with public submission enabled' do
      it 'renders a successful response' do
        get new_submission_path(layer_id: @layer.id, locale: 'en')
        expect(response).to be_successful
      end
    end
  end

  describe 'POST /en/1/submissions/create' do
    context 'with valid parameters' do
      it 'creates a new Submission' do
        expect do
          post submissions_path(layer_id: @layer.id, locale: 'en'), params: { submission: valid_attributes }
        end.to change(Submission, :count).by(1)
      end

      xit 'redirects to the created new place form' do
        post submissions_path(layer_id: @layer.id, locale: 'en'), params: { submission: valid_attributes }
        expect(response).to redirect_to(submission_new_place_path(locale: 'en', layer_id: @layer.id, submission_id: Submission.order('created_at').last.id))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Submission' do
        expect do
          post submissions_path(layer_id: @layer.id, locale: 'en'), params: { submission: invalid_attributes }
        end.to change(Submission, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post submissions_path(layer_id: @layer.id, locale: 'en'), params: { submission: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end
end
