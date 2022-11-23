# frozen_string_literal: true

class PlacePolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    # raise Pundit::NotAuthorizedError, 'must be logged in' unless user
    @user = user
    @record = record
  end

  def index?
    true
    # user&.admin?
  end

  def show?
    user&.admin? || record.published? || record.user == user || user&.has_role?(:moderator, record.layer.map)
  end

  def update?
    user&.admin? || record.user == user || user&.has_role?(:moderator, record.layer.map)
  end

  def destroy?
    user&.admin? || user&.has_role?(:moderator, record.layer.map)
  end

  class Scope < Scope
    def resolve
      if user&.admin?
        scope.all
      # TODO: make this work
      # elsif user&.has_role?(:moderator, :any)
      # scope.where(map: Map.with_role(:moderator, user))
      elsif user&.blank?
        scope.where(published: true)
      else
        scope.where(published: true)
      end
    end
  end
end
