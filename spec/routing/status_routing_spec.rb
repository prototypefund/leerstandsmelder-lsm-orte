# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StatusController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/status').to route_to('status#index')
    end

    it 'routes to #new' do
      expect(get: '/status/new').to route_to('status#new')
    end

    it 'routes to #show' do
      expect(get: '/status/1').to route_to('status#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/status/1/edit').to route_to('status#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/status').to route_to('status#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/status/1').to route_to('status#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/status/1').to route_to('status#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/status/1').to route_to('status#destroy', id: '1')
    end
  end
end
