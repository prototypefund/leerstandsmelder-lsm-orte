# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
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

  def update?
    user.admin?
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
