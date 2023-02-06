# frozen_string_literal: true

class ImagePolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    # raise Pundit::NotAuthorizedError, 'must be logged in' unless user
    @user = user
    @record = record
  end

  def index?
    user&.admin? || !record.hidden? || record.user == user || user&.has_role?(:moderator, record.place.map)
  end

  def show?
    user&.admin? || !record.hidden? || record.user == user || user&.has_role?(:moderator, record.place.map)
  end

  class Scope < Scope
    def resolve
      if user&.admin?
        scope.all
      elsif user&.has_role?(:moderator, :any)
        # TODO: get moderator map etc.
        # scope.where(map: Map.with_role(:moderator, user).map(&:id))
        scope.all
      elsif user&.present?
        scope.where(hidden: false).or(where(user: user).where(hidden: true))
      elsif user&.blank?
        scope.where(hidden: false)
      else
        scope.where(hidden: false)
      end
    end
  end
end
