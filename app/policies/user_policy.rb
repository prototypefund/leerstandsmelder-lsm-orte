# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    # raise Pundit::NotAuthorizedError, 'must be logged in' unless user
    @user = user
    @record = record
  end

  class Scope < Scope
    def initialize(user, scope)
      super
      @user  = user
      @scope = scope
    end

    def resolve
      scope.all if user.admin?
    end
  end

  def permitted_attributes
    if user&.admin?
      %i[id email nickname roles role_keys created_at updated_at confirmed blocked message_me notify share_email accept_terms]
    elsif record.id == user&.id
      %i[id email nickname role_keys created_at updated_at message_me notify share_email]
    else
      %i[id nickname role_keys]
    end
  end

  def index?
    user.admin? # || record.id == user.id
  end

  def search?
    index?
  end

  def update?
    user.admin? # || record.id == user.id
  end

  def edit?
    update?
  end

  def show?
    update?
  end

  def create?
    true
  end

  def new?
    create?
  end

  def destroy?
    user.admin?
  end
end
