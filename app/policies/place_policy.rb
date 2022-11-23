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
    user&.admin? || record.published?
  end

  class Scope < Scope
    def resolve
      if user&.admin?
        scope.all
      elsif user&.blank?
        scope.where(published: true)
      else
        scope.where(published: true)
      end
    end
  end
end
