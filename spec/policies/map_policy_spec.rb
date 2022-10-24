# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MapPolicy, type: :policy do
  let(:user) { FactoryBot.create(:user) }
  let(:admin_user) { FactoryBot.create(:admin_user) }
  let(:map) { create(:map) }
  subject { described_class }

  permissions '.scope' do
    pending "add some examples to (or delete) #{__FILE__}"
  end

  permissions :show? do
    it 'denies access if map is unpublished' do
      expect(subject).not_to permit(user, Map.new(published: false))
    end
    it 'permits access if map is unpublished and user is an admin' do
      expect(subject).to permit(admin_user, Map.new(published: false))
    end
  end

  permissions :new?, :create? do
    it 'denies access if a client' do
      expect(subject).not_to permit(user, Map.new)
    end
    it 'grants access if user is an admin' do
      expect(subject).to permit(admin_user, Map.new)
    end
  end

  permissions :update? do
    it 'denies access if a client' do
      expect(subject).not_to permit(user, map.update({ published: true }))
    end
    it 'grants access if user is an admin' do
      expect(subject).to permit(admin_user, map.update({ published: true }))
    end
  end

  permissions :destroy? do
    it 'denies access if a client' do
      expect(subject.destroy?(user, map)).to eq(false)
    end
    it 'grants access if user is an admin' do
      expect(subject.destroy?(admin_user, map)).to eq(true)
    end
  end
end
