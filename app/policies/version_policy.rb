# frozen_string_literal: true

class VersionPolicy < ApplicationPolicy
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
    user&.admin? || record.user == user || user&.has_role?(:moderator, record.layer.map)
  end

  def update?
    user&.admin? || record.user == user || user&.has_role?(:moderator, record.layer.map)
  end

  def destroy?
    user&.admin? || user&.has_role?(:moderator, record.layer.map)
  end

  def user_places?
    # we dont have 1 record here but many (like index) so use the scope
    # user&.admin? || record.user_id == user.id
    index?
  end

  class Scope < Scope
    def resolve
      if user&.admin?
        scope.all
      elsif user&.has_role?(:moderator, :any)
        scope.where(map: Map.with_role(:moderator, user).map(&:id))
      elsif user&.present?
        scope.where(whodunnit: user)
      elsif user&.blank?
        nil
      end
    end
  end
end
