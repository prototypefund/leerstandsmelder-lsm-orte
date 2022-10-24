# frozen_string_literal: true

class MapPolicy < ApplicationPolicy
  attr_reader :user, :map

  def initialize(user, map)
    @user = user
    @map = map
  end

  def new?
    user.admin?
  end

  def edit?
    user.admin?
  end

  def create?
    user.admin?
  end

  def update?
    user.admin?
  end

  def show?
    user.admin? || map.published?
  end

  def self.destroy?(user, map)
    new(user, map).destroy?
  end

  def destroy?
    user.admin?
  end

  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.where(published: true)
      end
    end
  end
end
